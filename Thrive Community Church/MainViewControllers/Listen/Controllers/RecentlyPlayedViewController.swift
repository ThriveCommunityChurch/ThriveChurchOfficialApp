//
//  RecentlyPlayedViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 1/16/19.
//  Copyright © 2019 Thrive Community Church. All rights reserved.
//

import UIKit

class RecentlyPlayedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	// UI Elements
	let recentlyPlayedTable: UITableView = {
		let table = UITableView()
		table.frame = .zero
		table.indicatorStyle = .white
		table.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: table.frame.size.width, height: 1))
		table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		table.translatesAutoresizingMaskIntoConstraints = false
		return table
	}()

	let spinner: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		indicator.style = .large
		indicator.color = .white
		indicator.backgroundColor = .clear
		indicator.translatesAutoresizingMaskIntoConstraints = false
		return indicator
	}()

	// Variables
	var messages = [SermonMessage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up navigation
        title = "Recently Played"
        navigationController?.navigationBar.prefersLargeTitles = false

        // Register Table View info
		recentlyPlayedTable.delegate = self
		recentlyPlayedTable.dataSource = self

		self.recentlyPlayedTable.register(RecentlyWatchedTableViewCell.self,
										  forCellReuseIdentifier: "Cell")

		setupViews()

		// Fix iPad white bar issue - ensure view background extends to bottom edge
		view.backgroundColor = UIColor.bgDarkBlue

		// Ensure view fills entire screen (iOS 15+ minimum deployment target)
		extendedLayoutIncludesOpaqueBars = true
		edgesForExtendedLayout = .all

		// Ensure table view extends to bottom edge without white bar
		recentlyPlayedTable.contentInsetAdjustmentBehavior = .automatic

		// do this in the background because there's a lot of data here if the array is full
		DispatchQueue.main.async {
			self.retrieveRecentlyPlayed()
		}
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// Mark: - TableView

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = recentlyPlayedTable.dequeueReusableCell(withIdentifier: "Cell",
												   for: indexPath) as! RecentlyWatchedTableViewCell

		let message = messages[indexPath.row]
		let viewWidth = view.frame.width

		cell.date.text = message.Date
		cell.seriesArt.image = message.seriesArt?.uiImage

		if (message.Title.count > 22) && (viewWidth < 350) {
			cell.title.font = UIFont(name: "Avenir-Book", size: 10)
		}

		cell.title.text = message.Title

		if (message.PassageRef?.count ?? 0 > 15) && (viewWidth < 350) {
			cell.passageRef.font = UIFont(name: "Avenir-Light", size: 9)
		}

		cell.passageRef.text = message.PassageRef
		cell.speaker.text = message.Speaker

		// make the selection color less intense
		let selectedView = UIView()
		selectedView.backgroundColor = UIColor.darkGray
		cell.selectedBackgroundView = selectedView

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		recentlyPlayedTable.deselectRow(indexPath: indexPath)
		let selectedMessage = messages[indexPath.row]

		let alert = UIAlertController(title: selectedMessage.Title,
									  message: "Please select an action",
									  preferredStyle: .actionSheet)

		let listenAction = UIAlertAction(title: "Listen", style: .default) { (action) in

			// lets first check to see if they have this sermon message downloaded
			let localMessage = self.retrieveDownloadFromStorage(sermonMessageID: selectedMessage.MessageId)

			if (localMessage == nil) {

				// we created a globally shared instance of this variable, so that if we
				// close this VC it should keep playing
				DispatchQueue.main.async {

					// fire and forget this
					SermonAVPlayer.sharedInstance.initUsingRssString(rssUrl: selectedMessage.AudioUrl ?? "",
																	 sermonData: nil,
																	 selectedMessage: selectedMessage,
																	 seriesImage: selectedMessage.seriesArt?.uiImage ?? UIImage())
				}
			}
			else {
				DispatchQueue.main.async {
					SermonAVPlayer.sharedInstance.initLocally(selectedMessage: localMessage!)
				}
			}
		}

		let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (action) in

			// do this async on the main thread
			DispatchQueue.main.async {

				let sharedInstance = SermonAVPlayer.sharedInstance
				let isPlaying = sharedInstance.checkPlayingStatus()
				let isPaused = sharedInstance.checkPausedStatus()

				if isPlaying || isPaused {
					// we are currently playing something or if it's paused, so we can't remove that

					let data = sharedInstance.getDataForPlayback()
					let playingMessage = data?["message"] as? SermonMessage

					if selectedMessage.MessageId == playingMessage?.MessageId {
						// unable to remove this message

						self.presentBasicAlertWTitle(title: "Unable to Remove Item",
													 message: "This sermon message is currently being played")

						// don't progress further
						return
					}
				}

				self.messages.remove(at: indexPath.row)
				self.recentlyPlayedTable.reloadData()

				// if we are removing the last one we should dismiss this view
				if self.messages.isEmpty {

					// Delete the cache altogether for this
					UserDefaults.standard.removeObject(forKey: ApplicationVariables.RecentlyPlayed)
					UserDefaults.standard.synchronize()

					// dismiss self and return to the collection VC
					self.navigationController?.popViewController(animated: true)
				}
				else {
					// we also need to re-set the Cache for these values

					// before we can place objects into Defaults they have to be encoded
                    do {
                        let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: self.messages, requiringSecureCoding: true)

                        // we have a reference to this message in the above Defaults array,
                        // so store everything
                        UserDefaults.standard.set(encodedData, forKey: ApplicationVariables.RecentlyPlayed)
                        UserDefaults.standard.synchronize()
                    }
                    catch {

                    }
				}
			}
		}

		let readPassageAction = UIAlertAction(title: "Read \(selectedMessage.PassageRef ?? "")", style: .default) { (action) in

			let vc = ReadSermonPassageViewController()
			vc.Passage = selectedMessage.PassageRef ?? ""

			// load the API domain from the Cache
			if let loadedData = UserDefaults.standard.string(forKey: ApplicationVariables.ApiCacheKey) {

				let apiDomain = loadedData
				vc.API = apiDomain
				self.show(vc, sender: self)
			}
			else {
				print("ERR: Error Ocurred while trying to read the API domain from User Defaults")
			}
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		// add the actions and present the alert
		alert.addAction(listenAction)
		alert.addAction(readPassageAction)
		alert.addAction(removeAction)
		alert.addAction(cancelAction)

		// Configure popover for iPad
		if let popover = alert.popoverPresentationController {
			if let cell = recentlyPlayedTable.cellForRow(at: indexPath) {
				popover.sourceView = cell
				popover.sourceRect = cell.bounds
			} else {
				popover.sourceView = recentlyPlayedTable
				popover.sourceRect = CGRect(x: recentlyPlayedTable.bounds.midX, y: recentlyPlayedTable.bounds.midY, width: 0, height: 0)
			}
			popover.permittedArrowDirections = [.up, .down]
		}

		self.present(alert, animated: true, completion: nil)
	}

	// MARK: - Methods
	func setupViews() {

		// Use consistent background color to prevent white bars
		view.backgroundColor = UIColor.bgDarkBlue

		// add subviews
		view.addSubview(recentlyPlayedTable)
		view.addSubview(spinner)

		// constraints
		NSLayoutConstraint.activate([
			recentlyPlayedTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			recentlyPlayedTable.topAnchor.constraint(equalTo: view.topAnchor),
			recentlyPlayedTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			recentlyPlayedTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])

		// Use consistent background color for table view
		self.recentlyPlayedTable.backgroundColor = UIColor.bgDarkBlue
		self.spinner.startAnimating()
	}

	func retrieveRecentlyPlayed() {

		// reading from the messageId collection in UD
		let decoded = UserDefaults.standard.object(forKey: ApplicationVariables.RecentlyPlayed) as? Data
		if decoded != nil {

            var decodedSermonMessages: [SermonMessage] = [SermonMessage]()

            // Use secure coding with explicit allowed classes
            let allowedClasses = NSSet(array: [
                NSArray.self,
                SermonMessage.self,
                NSString.self,
                NSNumber.self,
                NSData.self,
                NSDate.self,
                NSURL.self
            ])

            do {
                if let array = try NSKeyedUnarchiver.unarchivedObject(ofClasses: allowedClasses as! Set<AnyHashable>, from: decoded!) as? [SermonMessage] {
                    decodedSermonMessages = array
                } else {
                    decodedSermonMessages = [SermonMessage]()
                }
            } catch {
                decodedSermonMessages = [SermonMessage]()
                self.spinner.stopAnimating()
                return
            }

			// get the recently played sermon messages
			self.messages = decodedSermonMessages

			self.recentlyPlayedTable.reloadData()
		}

		self.spinner.stopAnimating()
	}

	// MARK: - Helper Methods
	// Note: retrieveDownloadFromStorage(sermonMessageID:) is available from ViewControllerExtension
}
