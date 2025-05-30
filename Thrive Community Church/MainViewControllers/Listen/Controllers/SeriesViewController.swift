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
			self.seriesArt.image = seriesImage
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
	let seriesArt: UIImageView = {
		let image = UIImageView()
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
		table.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: table.frame.size.width, height: 1))
		table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func setupViews() {
		// setup the view itself
		view.backgroundColor = UIColor.bgDarkBlue
		
		// add all the subviews
		view.addSubview(seriesArt)
		view.addSubview(startDate)
		view.addSubview(seriesTable)
		
		let width = view.frame.width
		let height = (width) * (9 / 16) // 16x9 ratio
		
		NSLayoutConstraint.activate([
			seriesArt.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			seriesArt.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			seriesArt.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			seriesArt.heightAnchor.constraint(equalToConstant: height),
			startDate.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
			startDate.topAnchor.constraint(equalTo: seriesArt.bottomAnchor, constant: 16),
			seriesTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			seriesTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			seriesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			seriesTable.topAnchor.constraint(equalTo: startDate.bottomAnchor, constant: 16)
		])
		
		let updatedSeriesInfo = formatDataForPresentation(series: series!)
		
		// set the properties
		if series?.StartDate != nil && series?.EndDate == nil {
			startDate.text = "Current Series"
		}
		else {
			// set the updated information
			startDate.text = "Started: \(updatedSeriesInfo.StartDate)"
		}
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
		
		if (localMessage == nil) {
            
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
		else {
			DispatchQueue.main.async {
				SermonAVPlayer.sharedInstance.initLocally(selectedMessage: localMessage!)
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
		
		DispatchQueue.main.async {
			let selectedMessage = self.messages[indexPath.row]
			
			cell.title.text = selectedMessage.Title
			cell.weekNum.text = "\(selectedMessage.WeekNum ?? 0)"
			cell.date.text = selectedMessage.Date
			cell.speaker.text = selectedMessage.Speaker
			cell.durationLabel.text = selectedMessage.AudioDuration?.formatDurationForUI()
		
			if selectedMessage.AudioUrl == nil {
				
				// if this sermon message has no audio associated with it then we need to
				// hide the image as well as the playback label
				cell.listenImage.isHidden = true
				cell.durationLabel.isHidden = true
			}
			else {
				cell.listenImage.isHidden = false
			}
			
			if selectedMessage.VideoUrl == nil {
				cell.watchImage.isHidden = true
			}
			else {
				cell.watchImage.isHidden = false
			}
			
			// make the selection color less intense
			let selectedView = UIView()
			selectedView.backgroundColor = UIColor.darkGray
			cell.selectedBackgroundView = selectedView
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
								
				DispatchQueue.main.async {
					let selectedRow = self.seriesTable.cellForRow(at: indexPath) as! SermonMessageTableViewCell
					
					selectedRow.downloadSpinner.startAnimating()
					
					// prevent multiple presses of the button
					if !self.currentlyDownloading {
						self.currentlyDownloading = true
						
						// check that the user has enough disk space
						let space = Storage.getFreeSpace().toMB()
						
						let size = selectedMessage.AudioFileSize ?? 0.0
						
						if size > space {
							
							// UI Elements need to be presented with the main method
							// we should invoke this on the main thread asyncronously
							DispatchQueue.main.async {
								
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
								
								self.currentlyDownloading = false
								self.presentBasicAlertWTitle(title: "Error!",
															 message: "Unable to download sermon message. " +
									"Please clear some space and try again. \(reqSpaceString) MB needed.")
							}
						}
						else {

							self.saveFileToDisk(selectedRow: selectedRow, selectedMessage: selectedMessage)
						}
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
	
	private func saveFileToDisk(selectedRow: SermonMessageTableViewCell, selectedMessage: SermonMessage) {
		
		let filename = "\(messageForDownload?.MessageId ?? "").mp3"
		
		let documentsDirectory = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory,
														  in: FileManager.SearchPathDomainMask.userDomainMask).last!
		
		let outputURL = documentsDirectory.appendingPathComponent(filename)
		
		// so we need to make sure that the file that we downloaded does not already have a file
		// where we want to put it, there's not already something there
		let storageLocationAvailable = !FileManager.default.fileExists(atPath: "\(outputURL)")
		
		if !storageLocationAvailable {
			
			self.presentBasicAlertWTitle(title: "Error!",
										 message: "An error occurred while attempting " +
				"to download the file. Please ensure that this file is not already downloaded.")
		}
		
		// download it again, since taking the AVPlayer Data and storing it is annoyingly hard
		let url = URL(string: (messageForDownload?.AudioUrl)!)!
		
		// set up your download task, progress on this seems a bit too far https://stackoverflow.com/a/30543917/6448167
		URLSession.shared.downloadTask(with: url) { (location, response, error) -> Void in
			
			if error != nil {
				print(error as Any)
			}
			
			if location == nil || response == nil {
				print("Response or location are nil, failing")
				return
			}
			else {
				// what do we wanna do if this download fails or never finishes
				
				guard let httpURLResponse = response as? HTTPURLResponse,
					httpURLResponse.statusCode == 200,
					let mimeType = response?.mimeType, mimeType.hasPrefix("audio"),
					let location = location, error == nil
					else { return }
				do {
					
					// we already checked this above
					if storageLocationAvailable {
						
						DispatchQueue.main.async {
							selectedRow.downloadSpinner.stopAnimating()
						}
						
						try FileManager.default.moveItem(at: location, to: outputURL)
						
						self.messageForDownload?.LocalAudioURI = "\(outputURL)" // mp3
						self.finishDownload()
					}
				} catch {
					// an error ocurred
					self.currentlyDownloading = false
					
					self.presentBasicAlertWTitle(title: "Error!",
												 message: "An error occurred while attempting " +
													"to download the file. Please ensure that this file is not already downloaded." +
						"\n\nIf you continue to encounter this issue, send us an email via wyatt@thrive-fl.org.")
					
					print(error)
				}
			}
		}.resume()
	}
	
	private func finishDownload() {
		
		// update the message object for the new URI for that saved audio on the device
		let currentUTCmilis = Date().timeIntervalSince1970 * 1000
		messageForDownload?.DownloadedOn = currentUTCmilis
		
		// NEXT: Update the list in memory and then use that list to update the one in Defaults
		addMessageToDownloadList()
		
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
