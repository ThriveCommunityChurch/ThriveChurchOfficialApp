//
//  SermonDownloadsViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/31/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit
import AVFoundation


class SermonDownloadsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
	
	var downloadedMessages = [SermonMessage]()
	var downloadedMessageIds = [String]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationItem.title = "Downloads"
		
		// register the cell class
		self.downloadsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		
       	setupViews()
		retrieveDownloadsFromStorage()
    }
	
	
	// MARK: - Table View Delegate Methods

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return downloadedMessages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = downloadsTableView.dequeueReusableCell(withIdentifier: "Cell",
												   for: indexPath)
		
		let message = downloadedMessages[indexPath.row]
		
		cell.textLabel?.text = message.Title
		
		return cell
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
		
		sortMessageData()
	}
	
	func sortMessageData() {
		
		// we need to sort the messages by most recently downloaded, and perhaps
		// give the user an option for sorting, either by name or by date given
	}

}
