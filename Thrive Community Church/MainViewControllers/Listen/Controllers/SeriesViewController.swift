//
//  SeriesViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/28/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit
import AVFoundation

class SeriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	// MARK: - Setters
	// public setters that need to be init before we can transition
	public var seriesImage = UIImage() {
		didSet {
			// Ensure we're on the main thread for UI updates
			DispatchQueue.main.async {
				// Always set the main series art image
				self.seriesArt.image = self.seriesImage

				// Only set background image for iPad (layered design)
				if UIDevice.current.userInterfaceIdiom == .pad {
					self.backgroundImageView.image = self.seriesImage
				}

				// Debug logging to help track image sizing issues
				if let image = self.seriesImage.cgImage {
					let imageSize = CGSize(width: image.width, height: image.height)
					let aspectRatio = Double(image.width) / Double(image.height)
					print("SeriesViewController: Image loaded - Size: \(imageSize), Aspect Ratio: \(String(format: "%.2f", aspectRatio))")
				}
			}
		}
	}

	public var SermonSeries: SermonSeries? {
		didSet {
			self.title = SermonSeries?.Name
			series = SermonSeries
			weekNum = series?.Messages.count ?? 0
		}
	}

	var messages = [SermonMessage]()
	var weekNum: Int = 0
	var downloadedMessageIds: [String] = [String]()
	var downloadedMessagesInSeries = [String]()
	var currentlyDownloading: Bool = false
	var messageForDownload: SermonMessage?
	var esvApiKey: String = ""
    var internetConnectionStatus: Network.Status = .unreachable
    var apiUrl: String = ""
    var apiDomain = "nil"

	private var series: SermonSeries?

	// MARK: - UI Elements

	// Container view for shadow effects
	private let seriesArtContainer: UIView = {
		let container = UIView()
		container.backgroundColor = .clear
		container.layer.cornerRadius = 12
		container.layer.shadowColor = UIColor.black.cgColor
		container.layer.shadowOffset = CGSize(width: 0, height: 4)
		container.layer.shadowRadius = 8
		container.layer.shadowOpacity = 0.4
		container.layer.masksToBounds = false
		container.translatesAutoresizingMaskIntoConstraints = false
		return container
	}()

	// Background image view with blur effect for full-width coverage
	private let backgroundImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .darkGrey
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 12
		imageView.layer.masksToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false

		// Add blur effect
		let blurEffect = UIBlurEffect(style: .dark)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.translatesAutoresizingMaskIntoConstraints = false
		imageView.addSubview(blurEffectView)

		// Make blur effect fill the entire image view
		NSLayoutConstraint.activate([
			blurEffectView.topAnchor.constraint(equalTo: imageView.topAnchor),
			blurEffectView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
			blurEffectView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
			blurEffectView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
		])

		return imageView
	}()

	let seriesArt: UIImageView = {
		let image = UIImageView()
		image.backgroundColor = .clear // Clear background since we have the blurred background
		image.contentMode = .scaleAspectFill // Use scaleAspectFill to ensure image fills the space
		image.layer.cornerRadius = 12
		image.layer.masksToBounds = true
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}()

	let startDate: UILabel = {
		let label = UILabel()
		label.textColor = .lightGray
		label.font = UIFont(name: "Avenir-Book", size: 16)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let seriesTable: UITableView = {
		let table = UITableView()
		table.backgroundColor = UIColor.almostBlack
		table.frame = .zero
		table.indicatorStyle = .white
		table.separatorStyle = .none
		table.showsVerticalScrollIndicator = true
		table.contentInsetAdjustmentBehavior = .automatic
		table.estimatedRowHeight = 120
		table.rowHeight = UITableView.automaticDimension
		table.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: table.frame.size.width, height: 20))
		table.translatesAutoresizingMaskIntoConstraints = false
		return table
	}()

	// MARK: - Methods

	override func viewDidLoad() {
		super.viewDidLoad()

		seriesTable.delegate = self
		seriesTable.dataSource = self

		self.seriesTable.register(SermonMessageTableViewCell.self, forCellReuseIdentifier: "Cell")

		setupViews()
		loadMessagesForSeries()
		loadDownloadedMessages()

		// look to see if this is different, if not do nothing different
		if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
			let nsDictionary = NSDictionary(contentsOfFile: path)

			self.esvApiKey = nsDictionary?[ApplicationVariables.ESVApiCacheKey] as? String ?? ""
		}

		// Ensure view background matches to prevent white bars
		view.backgroundColor = UIColor.bgDarkBlue

		// Ensure table view extends to bottom edge without white bar (iOS 15+ minimum deployment target)
		seriesTable.contentInsetAdjustmentBehavior = .automatic

		// Ensure view fills entire screen
		extendedLayoutIncludesOpaqueBars = true
		edgesForExtendedLayout = .all
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		// Ensure the blur effect view maintains proper bounds
		// This helps with any layout issues during rotation or initial load
		if UIDevice.current.userInterfaceIdiom == .pad {
			if let blurView = backgroundImageView.subviews.first(where: { $0 is UIVisualEffectView }) {
				blurView.frame = backgroundImageView.bounds
			}
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
	}

	// Store constraints for proper cleanup during rotation
	private var currentConstraints: [NSLayoutConstraint] = []

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)

		// Update constraints after rotation completes
		coordinator.animate(alongsideTransition: nil) { _ in
			// Deactivate current constraints cleanly
			NSLayoutConstraint.deactivate(self.currentConstraints)
			self.currentConstraints.removeAll()

			// Recalculate and apply new constraints for the new orientation
			self.updateConstraintsForCurrentOrientation()
		}
	}

	private func updateConstraintsForCurrentOrientation() {
		// Calculate new dimensions
		let screenWidth = view.frame.width
		let screenHeight = view.frame.height
		let cardMargin: CGFloat = 16
		let cardWidth = screenWidth - (cardMargin * 2)

		// Calculate card height with device-specific considerations
		let isIPad = UIDevice.current.userInterfaceIdiom == .pad
		let isLandscape = screenWidth > screenHeight

		var cardHeight: CGFloat

		if isIPad {
			if isLandscape {
				// iPad landscape: Use a more generous portion for better visual impact
				cardHeight = min(screenHeight * 0.5, cardWidth * 0.7) // Max 50% of height or 70% of width
			} else {
				// iPad portrait: Use a balanced approach that's more prominent
				cardHeight = min(screenHeight * 0.4, cardWidth * 0.8) // Max 40% of height or 80% of width
			}
		} else {
			// iPhone: Use strict 16:9 aspect ratio for consistent appearance
			cardHeight = cardWidth * (9.0 / 16.0) // Traditional 16:9 ratio
		}

		// Check if this is the current series (no EndDate)
		let isCurrentSeries = series?.StartDate != nil && series?.EndDate == nil

		// Setup container constraints (with margins for modern card design)
		let containerConstraints = [
			seriesArtContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: cardMargin),
			seriesArtContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -cardMargin),
			seriesArtContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: cardMargin),
			seriesArtContainer.heightAnchor.constraint(equalToConstant: cardHeight)
		]

		// Setup image constraints based on device type
		var imageConstraints: [NSLayoutConstraint] = []

		if isIPad {
			// iPad: Setup layered design with background and foreground images
			let backgroundImageConstraints = [
				backgroundImageView.topAnchor.constraint(equalTo: seriesArtContainer.topAnchor),
				backgroundImageView.leadingAnchor.constraint(equalTo: seriesArtContainer.leadingAnchor),
				backgroundImageView.trailingAnchor.constraint(equalTo: seriesArtContainer.trailingAnchor),
				backgroundImageView.bottomAnchor.constraint(equalTo: seriesArtContainer.bottomAnchor)
			]

			// iPad foreground image: centered with 16:9 aspect ratio for proper image display
			let padding: CGFloat = 32 // More generous padding for iPad layered design
			let foregroundImageConstraints = [
				seriesArt.centerXAnchor.constraint(equalTo: seriesArtContainer.centerXAnchor),
				seriesArt.centerYAnchor.constraint(equalTo: seriesArtContainer.centerYAnchor),
				seriesArt.leadingAnchor.constraint(greaterThanOrEqualTo: seriesArtContainer.leadingAnchor, constant: padding),
				seriesArt.trailingAnchor.constraint(lessThanOrEqualTo: seriesArtContainer.trailingAnchor, constant: -padding),
				seriesArt.topAnchor.constraint(greaterThanOrEqualTo: seriesArtContainer.topAnchor, constant: padding),
				seriesArt.bottomAnchor.constraint(lessThanOrEqualTo: seriesArtContainer.bottomAnchor, constant: -padding),
				// CRITICAL: Maintain 16:9 aspect ratio for proper image display
				seriesArt.widthAnchor.constraint(equalTo: seriesArt.heightAnchor, multiplier: 16.0/9.0)
			]

			// Add priority constraints to make the foreground image as large as possible within padding
			// while respecting the 16:9 aspect ratio
			let widthConstraint = seriesArt.widthAnchor.constraint(equalTo: seriesArtContainer.widthAnchor, constant: -padding * 2)
			let heightConstraint = seriesArt.heightAnchor.constraint(equalTo: seriesArtContainer.heightAnchor, constant: -padding * 2)
			widthConstraint.priority = UILayoutPriority(998) // Lower priority than aspect ratio
			heightConstraint.priority = UILayoutPriority(998) // Lower priority than aspect ratio

			imageConstraints = backgroundImageConstraints + foregroundImageConstraints + [widthConstraint, heightConstraint]
		} else {
			// iPhone: Simple single-image approach filling the entire container
			imageConstraints = [
				seriesArt.topAnchor.constraint(equalTo: seriesArtContainer.topAnchor),
				seriesArt.leadingAnchor.constraint(equalTo: seriesArtContainer.leadingAnchor),
				seriesArt.trailingAnchor.constraint(equalTo: seriesArtContainer.trailingAnchor),
				seriesArt.bottomAnchor.constraint(equalTo: seriesArtContainer.bottomAnchor)
			]
		}

		// Setup table and label constraints
		var layoutConstraints: [NSLayoutConstraint] = []

		if isCurrentSeries {
			// Current series: show "Current Series" text and normal layout
			startDate.text = "Current Series"
			startDate.isHidden = false

			let currentSeriesConstraints = [
				startDate.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
				startDate.topAnchor.constraint(equalTo: seriesArtContainer.bottomAnchor, constant: 16),
				seriesTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				seriesTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				seriesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
				seriesTable.topAnchor.constraint(equalTo: startDate.bottomAnchor, constant: 16)
			]

			layoutConstraints = currentSeriesConstraints
		} else {
			// Non-current series: hide text and make table touch bottom of image
			startDate.isHidden = true

			let nonCurrentSeriesConstraints = [
				seriesTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				seriesTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				seriesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
				seriesTable.topAnchor.constraint(equalTo: seriesArtContainer.bottomAnchor, constant: 16)
			]

			layoutConstraints = nonCurrentSeriesConstraints
		}

		// Store and activate all constraints
		currentConstraints = containerConstraints + imageConstraints + layoutConstraints
		NSLayoutConstraint.activate(currentConstraints)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func setupViews() {
		// setup the view itself
		view.backgroundColor = UIColor.bgDarkBlue

		// add all the subviews with modern card-based hierarchy
		view.addSubview(seriesArtContainer)

		// iPad-specific constraints for landscape orientation
		let isIPad = UIDevice.current.userInterfaceIdiom == .pad

		if isIPad {
			// iPad: Use layered design with blurred background
			seriesArtContainer.addSubview(backgroundImageView) // Add background first
			seriesArtContainer.addSubview(seriesArt) // Add foreground on top
		} else {
			// iPhone: Use simple single-image approach
			seriesArtContainer.addSubview(seriesArt) // Only add the main image
		}

		view.addSubview(startDate)
		view.addSubview(seriesTable)

		// Use the new constraint management system
		updateConstraintsForCurrentOrientation()
	}

	func formatDataForPresentation(series: SermonSeries) -> SermonSeries{

		var response = series

		// format dates
		response.StartDate = series.StartDate.FormatDateFromISO8601ForUI()

		return response
	}

	func loadMessagesForSeries() {

		for i in (series?.Messages)! {
			i.WeekNum = weekNum
			weekNum = weekNum - 1

			let date = i.Date.FormatDateFromISO8601ForUI()
			i.Date = date
			i.seriesTitle = series?.Name

			messages.append(i)
		}

		seriesTable.reloadData()
	}

	func playSermonAudio(rssUrl: String, message: SermonMessage) {

		// lets first check to see if they have this sermon message downloaded
		let localMessage = retrieveDownloadFromStorage(sermonMessageID: message.MessageId)

		if let downloadedMessage = localMessage {
			// Play from downloaded file
			print("Playing downloaded sermon: \(downloadedMessage.Title)")
			DispatchQueue.main.async {
				self.markMessagePlayed(messageId: message.MessageId)
				SermonAVPlayer.sharedInstance.initLocally(selectedMessage: downloadedMessage)
			}
		} else {
			// Stream from server
            checkConnectivity()

            if internetConnectionStatus != .unreachable {

                // we created a globally shared instance of this variable, so that if we
                // close this VC it should keep playing
                DispatchQueue.main.async {

                self.markMessagePlayed(messageId: message.MessageId)

                // fire and forget this
                SermonAVPlayer.sharedInstance.initUsingRssString(rssUrl: rssUrl,
                                                                 sermonData: self.series!,
                                                                 selectedMessage: message,
                                                                 seriesImage: self.seriesImage)
                }

            }
            else {

                let alert = UIAlertController(title: "Oops!",
                                              message: "You are currently offline. Please reconnect and again later.",
                                              preferredStyle: .alert)

                let okAction = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(okAction)

                self.present(alert, animated: true, completion: nil)
            }
		}
	}

    func checkConnectivity() {
        // check status
        guard let status = Network.reachability?.status else { return }
        self.internetConnectionStatus = status

        // override this on the Simulator and that way we can still develop things
        if UIDevice.current.modelName == "Simulator" || UIDevice.current.modelName == "arm64" {
            self.internetConnectionStatus = .wifi
        }
    }

    func markMessagePlayed(messageId: String) {

        // contact the API on the address we have cached
        if let loadedData = UserDefaults.standard.string(forKey: ApplicationVariables.ApiCacheKey) {

            apiDomain = loadedData
            apiUrl = "http://\(apiDomain)/"
        }

        // Note to self: This is being cached and updates to this will require an
        // app restart in order to view changes on a series that is NOT the current one

        let thing = "\(apiUrl)api/sermons/series/message\(messageId)/played"
        let url = NSURL(string: thing)
        URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in

            // something went wrong here
            if error != nil {

                // in this case we don't need to tell the user that this reuquest failed

                return
            }
        }.resume()
    }

	// MARK: - Table View

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = seriesTable.dequeueReusableCell(withIdentifier: "Cell",
												   for: indexPath) as! SermonMessageTableViewCell

		let selectedMessage = messages[indexPath.row]

		// Configure cell content
		cell.title.text = selectedMessage.Title
		cell.weekNum.text = "\(selectedMessage.WeekNum ?? 0)"
		cell.date.text = selectedMessage.Date
		cell.speaker.text = selectedMessage.Speaker

		// Configure duration
		if let duration = selectedMessage.AudioDuration?.formatDurationForUI() {
			cell.durationLabel.text = duration
			cell.durationLabel.isHidden = false
		} else {
			cell.durationLabel.isHidden = true
		}

		// Configure media availability using new methods
		cell.setAudioAvailable(selectedMessage.AudioUrl != nil)
		cell.setVideoAvailable(selectedMessage.VideoUrl != nil)

		// Configure download status
		if downloadedMessagesInSeries.contains(selectedMessage.MessageId) {
			cell.showDownloadedStatus()
		} else {
			cell.hideDownloadProgress()
		}

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let selectedMessage = messages[indexPath.row]
		messageForDownload = selectedMessage

		// tapping on an item that has no options doesn't do anything
		if selectedMessage.AudioUrl == nil && selectedMessage.VideoUrl == nil &&
			selectedMessage.PassageRef == nil
			{
				self.seriesTable.deselectRow(indexPath: indexPath)
				return
			}

		let alert = UIAlertController(title: "\(series?.Name ?? "") - Week \(selectedMessage.WeekNum ?? 0)",
									  message: "Please select an action",
									  preferredStyle: .actionSheet)
		var listenAction: UIAlertAction
		var watchAction: UIAlertAction
		var downloadAction: UIAlertAction

		// these ifs both will prevent the Alert Actions from appearing if the message
		// does not have this property set
		if selectedMessage.AudioUrl != nil {

			listenAction = UIAlertAction(title: "Listen", style: .default) { (action) in

				self.seriesTable.deselectRow(indexPath: indexPath)

				// init a new shared instance of our AVPlayer, any VC has access to this
				self.playSermonAudio(rssUrl: selectedMessage.AudioUrl!, message: selectedMessage)
			}

			alert.addAction(listenAction)
		}

		if selectedMessage.VideoUrl != nil {

			watchAction = UIAlertAction(title: "Watch in HD", style: .default) { (action) in

				self.seriesTable.deselectRow(indexPath: indexPath)

				var youtubeId = selectedMessage.VideoUrl ?? ""
				youtubeId = youtubeId.replacingOccurrences(of: "https://youtu.be/", with: "")

				// register this one in recently played when they click to watch the video
				// after this point, we don't REALLY care if they watched it or not
				let selectedMessage = self.messages[indexPath.row]
				selectedMessage.registerDataForRecentlyPlayed(seriesImage: self.seriesArt.image)

				let videoView = ViewPlayerViewController()
				videoView.VideoId = youtubeId
				videoView.Message = selectedMessage

				self.navigationController?.show(videoView, sender: self)
			}

			alert.addAction(watchAction)
		}

		// check if this message has been downloaded as part of this series yet
		// if it has not we need to make sure that we don't try to download something we can't
		if !downloadedMessagesInSeries.contains(selectedMessage.MessageId) &&
			!self.currentlyDownloading && selectedMessage.AudioUrl != nil {

			downloadAction = UIAlertAction(title: "Download Week \(selectedMessage.WeekNum ?? 0)",
			style: .default) { (action) in

				self.seriesTable.deselectRow(indexPath: indexPath)

				// prevent multiple presses of the button
				if !self.currentlyDownloading {
					self.currentlyDownloading = true

					// Show download progress immediately
					DispatchQueue.main.async {
						if let selectedRow = self.seriesTable.cellForRow(at: indexPath) as? SermonMessageTableViewCell {
							selectedRow.showDownloadProgress()
						}
					}

					// check that the user has enough disk space
					let space = Storage.getFreeSpace().toMB()
					let size = selectedMessage.AudioFileSize ?? 0.0

					if size > space {
						// UI Elements need to be presented with the main method
						// we should invoke this on the main thread asyncronously
						DispatchQueue.main.async {
							// Hide download progress and show error
							if let selectedRow = self.seriesTable.cellForRow(at: indexPath) as? SermonMessageTableViewCell {
								selectedRow.hideDownloadProgress()
							}

							// the user has no space to save this audio
							self.currentlyDownloading = false

							let requiredSpace = (size - space).rounded(toPlace: 2)
							var reqSpaceString: String = ""

							// if we have a number that is greater or equal to 1 then we
							// should try to remove the trailing zeros. If its less
							// than that we want them
							if requiredSpace >= 1.0 {
								reqSpaceString = requiredSpace.removeZerosFromEnd()
							}
							else {
								reqSpaceString = "\(requiredSpace)"
							}

							self.presentBasicAlertWTitle(title: "Error!",
														 message: "Unable to download sermon message. " +
								"Please clear some space and try again. \(reqSpaceString) MB needed.")
						}
					}
					else {
						self.saveFileToDisk(indexPath: indexPath, selectedMessage: selectedMessage)
					}
				}
			}

			alert.addAction(downloadAction)
		}

		if selectedMessage.PassageRef != nil {

			let readPassageAction = UIAlertAction(title: "Read \(selectedMessage.PassageRef ?? "")",
												  style: .default) { (action) in

				self.seriesTable.deselectRow(indexPath: indexPath)

				let vc = ReadSermonPassageViewController()
				vc.Passage = selectedMessage.PassageRef ?? ""

				if let loadedData = UserDefaults.standard.string(forKey: ApplicationVariables.ApiCacheKey) {

					let apiDomain = loadedData
					vc.API = apiDomain
					self.show(vc, sender: self)
				}
				else {
					print("ERR: Error Ocurred while trying to read the API domain from User Defaults")
				}

			}

			alert.addAction(readPassageAction)
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in

			self.seriesTable.deselectRow(indexPath: indexPath)
		}


		alert.addAction(cancelAction)

		// Configure popover for iPad
		if let popover = alert.popoverPresentationController {
			if let cell = seriesTable.cellForRow(at: indexPath) {
				popover.sourceView = cell
				popover.sourceRect = cell.bounds
			} else {
				popover.sourceView = seriesTable
				popover.sourceRect = CGRect(x: seriesTable.bounds.midX, y: seriesTable.bounds.midY, width: 0, height: 0)
			}
			popover.permittedArrowDirections = [.up, .down]
		}

		self.present(alert, animated: true, completion: nil)
	}

	private func addMessageToDownloadList() {

		self.downloadedMessageIds.append((messageForDownload?.MessageId)!)
		self.downloadedMessagesInSeries.append((messageForDownload?.MessageId)!)

		// we updated the list in memory, so write it down in defaults
		UserDefaults.standard.set(self.downloadedMessageIds, forKey: ApplicationVariables.DownloadedMessages)
		UserDefaults.standard.synchronize()

		// before we save this we need to make sure we set the series Art
		messageForDownload?.seriesArt = seriesImage.pngData()

		// before we can place objects into Defaults they have to be encoded
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: messageForDownload!, requiringSecureCoding: true)

            // we have a reference to this message in the above Defaults array, so store everything
            UserDefaults.standard.set(encodedData, forKey: (messageForDownload?.MessageId)!)
            UserDefaults.standard.synchronize()
        }
        catch {

        }

	}

	private func saveFileToDisk(indexPath: IndexPath, selectedMessage: SermonMessage) {

		let filename = "\(messageForDownload?.MessageId ?? "").mp3"

		let documentsDirectory = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory,
														  in: FileManager.SearchPathDomainMask.userDomainMask).last!

		let outputURL = documentsDirectory.appendingPathComponent(filename)

		// so we need to make sure that the file that we downloaded does not already have a file
		// where we want to put it, there's not already something there
		let storageLocationAvailable = !FileManager.default.fileExists(atPath: "\(outputURL)")

		if !storageLocationAvailable {
			DispatchQueue.main.async {
				// Hide download progress
				if let selectedRow = self.seriesTable.cellForRow(at: indexPath) as? SermonMessageTableViewCell {
					selectedRow.hideDownloadProgress()
				}

				self.currentlyDownloading = false
				self.presentBasicAlertWTitle(title: "Error!",
											 message: "An error occurred while attempting " +
					"to download the file. Please ensure that this file is not already downloaded.")
			}
			return
		}

		// download it again, since taking the AVPlayer Data and storing it is annoyingly hard
		let url = URL(string: (messageForDownload?.AudioUrl)!)!

		// set up your download task, progress on this seems a bit too far https://stackoverflow.com/a/30543917/6448167
		URLSession.shared.downloadTask(with: url) { (location, response, error) -> Void in

			if error != nil {
				print(error as Any)
				DispatchQueue.main.async {
					if let selectedRow = self.seriesTable.cellForRow(at: indexPath) as? SermonMessageTableViewCell {
						selectedRow.hideDownloadProgress()
					}
					self.currentlyDownloading = false
				}
				return
			}

			if location == nil || response == nil {
				print("Response or location are nil, failing")
				DispatchQueue.main.async {
					if let selectedRow = self.seriesTable.cellForRow(at: indexPath) as? SermonMessageTableViewCell {
						selectedRow.hideDownloadProgress()
					}
					self.currentlyDownloading = false
				}
				return
			}
			else {
				// what do we wanna do if this download fails or never finishes

				guard let httpURLResponse = response as? HTTPURLResponse,
					httpURLResponse.statusCode == 200,
					let mimeType = response?.mimeType, mimeType.hasPrefix("audio"),
					let location = location, error == nil
					else {
						DispatchQueue.main.async {
							if let selectedRow = self.seriesTable.cellForRow(at: indexPath) as? SermonMessageTableViewCell {
								selectedRow.hideDownloadProgress()
							}
							self.currentlyDownloading = false
						}
						return
					}
				do {

					// we already checked this above
					if storageLocationAvailable {
						try FileManager.default.moveItem(at: location, to: outputURL)

						self.messageForDownload?.LocalAudioURI = outputURL.path // Store file path, not URL string
						self.finishDownload(indexPath: indexPath)
					}
				} catch {
					// an error ocurred
					self.currentlyDownloading = false

					DispatchQueue.main.async {
						if let selectedRow = self.seriesTable.cellForRow(at: indexPath) as? SermonMessageTableViewCell {
							selectedRow.hideDownloadProgress()
						}

						self.presentBasicAlertWTitle(title: "Error!",
													 message: "An error occurred while attempting " +
														"to download the file. Please ensure that this file is not already downloaded." +
							"\n\nIf you continue to encounter this issue, send us an email via wyatt@thrive-fl.org.")
					}

					print(error)
				}
			}
		}.resume()
	}

	private func finishDownload(indexPath: IndexPath) {

		// update the message object for the new URI for that saved audio on the device
		let currentUTCmilis = Date().timeIntervalSince1970 * 1000
		messageForDownload?.DownloadedOn = currentUTCmilis

		// NEXT: Update the list in memory and then use that list to update the one in Defaults
		addMessageToDownloadList()

		// Update UI on main thread
		DispatchQueue.main.async {
			if let selectedRow = self.seriesTable.cellForRow(at: indexPath) as? SermonMessageTableViewCell {
				selectedRow.showDownloadedStatus()
			}
		}

		self.currentlyDownloading = false
		self.messageForDownload = nil
	}

	private func readDLMessageIds() {
		if let loadedData = UserDefaults.standard.array(forKey: ApplicationVariables.DownloadedMessages) as? [String] {

			self.downloadedMessageIds = loadedData
		}
	}

	private func loadDownloadedMessages() {
		if let loadedData = UserDefaults.standard.array(forKey: ApplicationVariables.DownloadedMessages) as? [String] {
			self.downloadedMessageIds = loadedData

			// we dont need the objects, thats too much
			for message in messages {

				// refine our list down slightly from a large list of all messages in any series
				// to only the ones in this series
				if loadedData.contains(message.MessageId) {

					// TODO: make this a NSMutableSet (HashSet)
					downloadedMessagesInSeries.append(message.MessageId)
				}
			}
		}
	}
}
