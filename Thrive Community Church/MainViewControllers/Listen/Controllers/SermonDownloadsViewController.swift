//
//  SermonDownloadsViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/31/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit
import AVFoundation


class SermonDownloadsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate {

	// UI Elements
	let downloadsTableView: UITableView = {
		let table = UITableView()
		table.backgroundColor = UIColor.almostBlack
		table.frame = .zero
		table.indicatorStyle = .white
		table.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: table.frame.size.width, height: 1))
		table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		table.translatesAutoresizingMaskIntoConstraints = false
		return table
	}()
	
	var sortingbutton: UIBarButtonItem?
	
	// Data types
	var downloadedMessages = [SermonMessage]()
	var downloadedMessageIds = [String]()
	
	// Sorting flags
	var alphaSelected: Bool = false
	var dateSelected: Bool = false
	var stampSelected: Bool = false
	var sizeSelected: Bool = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationItem.title = "Downloads"
		
		// register the cell class
		self.downloadsTableView.register(DownloadedMessageTableViewCell.self, forCellReuseIdentifier: "Cell")
		
		let image = UIImage(named: "sorting")
		sortingbutton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(openSortingOptions))
		sortingbutton?.tintColor = UIColor.white
		
		self.navigationItem.rightBarButtonItem = sortingbutton
		
       	setupViews()
		retrieveDownloadsFromStorage()
    }
	
	// MARK: - Table View Delegate Methods

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return downloadedMessages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = downloadsTableView.dequeueReusableCell(withIdentifier: "Cell",
												   for: indexPath) as! DownloadedMessageTableViewCell
		
		let message = downloadedMessages[indexPath.row]
		
		cell.titleLabel.text = message.Title
		cell.dateLabel.text = message.Date
		cell.speakerLabel.text = message.Speaker
		cell.storageSizeLabel.text = "\(message.downloadSizeMB?.rounded(toPlace: 1) ?? 0.0) MB"
		
		// make the selection color less intense
		let selectedView = UIView()
		selectedView.backgroundColor = UIColor.darkGray
		cell.selectedBackgroundView = selectedView
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let message = downloadedMessages[indexPath.row]
		
		presentOptions(message: message, indexPath: indexPath)
	}
	
	// MARK: - Methods
	func setupViews() {
		
		downloadsTableView.delegate = self
		downloadsTableView.dataSource = self
		
		// add subviews
		view.addSubview(downloadsTableView)
		
		
		// constraints
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				downloadsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				downloadsTableView.topAnchor.constraint(equalTo: view.topAnchor),
				downloadsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				downloadsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			])
		} else {
			// Fallback on earlier versions
			NSLayoutConstraint.activate([
				downloadsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				downloadsTableView.topAnchor.constraint(equalTo: view.topAnchor),
				downloadsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				downloadsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			])
		}
	}
	
	func retrieveDownloadsFromStorage() {
		
		// reinit the object just to make sure that there's nothing in it
		self.downloadedMessages = [SermonMessage]()
		
		if let loadedData = UserDefaults.standard.array(forKey: ApplicationVariables.DownloadedMessages) as? [String] {
			self.downloadedMessageIds = loadedData
			
			// now for each of these we need to go to UD and grab the physical objects,
			// shouldn't take long since UD lookups are O(1) so at most O(n)
			
			for messageId in loadedData {
				
				// objects are stored in UD as
				let decoded = UserDefaults.standard.object(forKey: messageId) as? Data
				
				if decoded == nil {
					print("\nERR LOADING RSS: SermonMessage for ID \(messageId) could not be found in UserDefaults. The save operation may not have completed properly or synchronize() may not have been called.")
				}
				else {
				
					// reading from the messageId collection in UD
					let decodedSermonMessage = NSKeyedUnarchiver.unarchiveObject(with: decoded ?? Data()) as! SermonMessage
					
					self.downloadedMessages.append(decodedSermonMessage)
				}
			}
		}
		
		// set the initial sorting
		stampSelected = true
		sortMessagesByTimestampDesc()
		
		// however disable this button if there are only 1 items in the list
		// because sorting 1 item makes no sense
		if self.downloadedMessages.count == 1 {
			self.sortingbutton?.isEnabled = false
		}
	}
	
	func presentOptions(message: SermonMessage, indexPath: IndexPath) {
		
		let alert = UIAlertController(title: "\(message.Title)",
									  message: "Please select an action",
									  preferredStyle: .actionSheet)
		
		let listenAction = UIAlertAction(title: "Listen", style: .default) { (action) in
			// listening
			self.downloadsTableView.deselectRow(indexPath: indexPath)
			
			// look in the shared file folder for the mp3 and play it using
			SermonAVPlayer.sharedInstance.initLocally(selectedMessage: message)
			
		}
		
		let deleteAction = UIAlertAction(title: "Remove Download", style: .default) { (action) in
			// Deleting
			self.downloadsTableView.deselectRow(indexPath: indexPath)
			
			// look in the shared file folder for the mp3 and play it using
			// SermonAVPlayer.sharedInstance
			do {
				let fileUrl = URL(string: message.LocalAudioURI!)
			    try FileManager.default.removeItem(at: fileUrl!)
				print("File deleted")
			}
			catch {
				print("\n\nERR: Delete Failed. File not found...\n\n")
			}
			UserDefaults.standard.removeObject(forKey: message.MessageId)
			
			self.downloadedMessageIds.removeAll(where: { (value) -> Bool in
				value == message.MessageId
			})
			
			// remove it from memory
			self.downloadedMessages.remove(at: indexPath.row)
			self.downloadsTableView.reloadData()
			
			// remove from UD
			UserDefaults.standard.set(self.downloadedMessageIds, forKey: ApplicationVariables.DownloadedMessages)
			UserDefaults.standard.synchronize()
			
			print("Successfully deleted download")
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
			self.downloadsTableView.deselectRow(indexPath: indexPath)
		}
		
		alert.addAction(listenAction)
		alert.addAction(deleteAction)
		alert.addAction(cancelAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	@objc func openSortingOptions() {
		
		// popover? see https://github.com/kmcgill88/McPicker-iOS
		
		let alert = UIAlertController(title: "Sorting Options",
									  message: "Please select a sorting option",
									  preferredStyle: .actionSheet)
		
		var alphabeticalOption: UIAlertAction?
		var dateOption: UIAlertAction?
		var stampOption: UIAlertAction?
		var sizeOption: UIAlertAction?
		
		if !alphaSelected {
			alphabeticalOption = UIAlertAction(title: "Alphabetically",
											   style: .default) { (action) in
												
				// sort by the name of each message
				self.sortAlphaAsc()
				self.alphaSelected = true
				self.dateSelected = false
				self.stampSelected = false
			}
			alert.addAction(alphabeticalOption ?? UIAlertAction())
		}
		
		if !dateSelected {
			dateOption = UIAlertAction(title: "Message Date",
									   style: .default) { (action) in
											
				// sort by the day this sermon was given
				self.sortMessageDateDesc()
				self.alphaSelected = false
				self.dateSelected = true
				self.stampSelected = false
				self.sizeSelected = false
			}
			alert.addAction(dateOption ?? UIAlertAction())
		}
		
		if !stampSelected {
			stampOption = UIAlertAction(title: "Date Downloaded",
										style: .default) { (action) in
											
				// sort by the day this sermon was downloaded
				self.sortMessagesByTimestampDesc()
				self.alphaSelected = false
				self.dateSelected = false
				self.stampSelected = true
				self.sizeSelected = false
			}
			alert.addAction(stampOption ?? UIAlertAction())
		}
		
		if !sizeSelected {
			sizeOption = UIAlertAction(title: "File Size",
										style: .default) { (action) in
											
				// sort by the day this sermon was downloaded
				self.sortMessagesBySizeDesc()
				self.alphaSelected = false
				self.dateSelected = false
				self.stampSelected = false
				self.sizeSelected = true
			}
			alert.addAction(sizeOption ?? UIAlertAction())
		}
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(cancel)
		
		self.present(alert, animated: true, completion: nil)
	}
	
	func sortMessageDateDesc() {
		
		let formatter = DateFormatter()
		formatter.dateFormat = "M.d.yy"
		
		self.downloadedMessages = self.downloadedMessages.sorted {
			formatter.date(from: $1.Date) ?? Date() < formatter.date(from: $0.Date) ?? Date()
		}
		
		self.downloadsTableView.reloadData()
	}
	
	func sortAlphaAsc() {
		
		self.downloadedMessages = self.downloadedMessages.sorted {
			$0.Title < $1.Title
		}
		
		self.downloadsTableView.reloadData()
	}
	
	func sortMessagesByTimestampDesc() {
		
		self.downloadedMessages = self.downloadedMessages.sorted {
			// this Anonymous closure means is the one after the one we are looking at less than this one?
			// if so then it goes before us, otherwise we are first, since higher numbers should be on top
			$1.DownloadedOn?.isLess(than: $0.DownloadedOn ?? 0.0) ?? false
		}
		
		self.downloadsTableView.reloadData()
	}
	
	func sortMessagesBySizeDesc() {
		
		self.downloadedMessages = self.downloadedMessages.sorted {
			// this Anonymous closure means is the one after the one we are looking at less than this one?
			// if so then it goes before us, otherwise we are first, since higher numbers should be on top
			$1.downloadSizeMB?.isLess(than: $0.downloadSizeMB ?? 0.0) ?? false
		}
		
		self.downloadsTableView.reloadData()
	}
}
