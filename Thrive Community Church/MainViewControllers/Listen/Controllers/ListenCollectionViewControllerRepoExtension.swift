//
//  ListenCollectionViewControllerRepoExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/24/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import MessageUI
import UIKit
import Firebase

extension ListenCollectionViewController {
	
	// MARK: - ThriveChurchOfficialAPI Requests
	
	func fetchAllSermons(isReset: Bool) {
		
		self.isLoading = true

		// sermons/page?PageNumber=pageNumber
		let url = NSURL(string: "\(apiUrl)api/sermons/paged?PageNumber=\(pageNumber)")
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			
			// something went wrong here
			if error != nil {
				print(error!)
				
				self.miscApiErrorText = "\(error!)"
				
				DispatchQueue.main.async {
					
					// we don't need to display the error message again
					if self.apiErrorMessage.isHidden {
						
						if self.internetConnectionStatus != .unreachable {
							self.enableErrorViews(status: self.internetConnectionStatus)
						}
						else {
							if self.apiErrorMessage.isHidden {
								self.enableErrorViews(status: self.internetConnectionStatus)
							}
						}
						
						if self.retryLimited {
							self.presentErrorAlert()
						}
					}
				}
				
				return
			}
			
			do {
				let pagedResponse = try JSONDecoder().decode(SermonsSummaryPagedResponse.self,
															 from: data!)
				
				self.totalPages = pagedResponse.PagingInfo.TotalPageCount

				if self.pageNumber >= self.totalPages {
					self.overrideFooter = true
				}
				
				for i in pagedResponse.Summaries {
					self.sermonSeries.append(i)
				}
				
				DispatchQueue.main.async {
					
					if isReset {
						self.checkIfApiResponseIsActive()
					}
					
					if self.pageNumber > 1 {
						self.isLoading = false
						self.footerView?.stopAnimate()
					}
					
					self.collectionView?.reloadData()
					
					self.disableLoadingScreen()
				}
			}
			catch let jsonError {
				print(jsonError)
			}
		}.resume()
	}
	
	func getSermonsForId(seriesId: String, image: UIImage) {
		
		// Note to self: This is being cached and updates to this will require an
		// app restart in order to view changes on a series that is NOT the current one
		
		let thing = "\(apiUrl)api/sermons/series/\(seriesId)"
		let url = NSURL(string: thing)
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			
			// something went wrong here
			if error != nil {
				
				DispatchQueue.main.async {
					self.miscApiErrorText = "\(error!)"
					
					if self.internetConnectionStatus != .unreachable {
						self.enableErrorViews(status: self.internetConnectionStatus)
					}
					else {
						if self.apiErrorMessage.isHidden {
							self.enableErrorViews(status: self.internetConnectionStatus)
						}
					}
					
					if self.retryLimited {
						self.presentErrorAlert()
					}
				}
				
				return
			}
			
			do {
				
				//let JSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
				
				let series = try JSONDecoder().decode(SermonSeries.self, from: data!)
				
				self.seriesMapping[seriesId] = series
				
				self.segueToSeriesDetailView(series: series, image: image)
			}
			catch let jsonError {
				print(jsonError)
			}
		}.resume()
	}
	
	func segueToSeriesDetailView(series: SermonSeries, image: UIImage) {
		
		DispatchQueue.main.async {
			// transition to another view
			
			let vc = SeriesViewController()
			vc.SermonSeries = series
			vc.seriesImage = image
			
			self.show(vc, sender: self)
		}
	}
	
	func fetchLiveStream() {

		let thing = "\(apiUrl)api/sermons/live/"
		let url = NSURL(string: thing)
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in

			// something went wrong here
			if error != nil {
				
				print("ERR returning live sermons \(String(describing: error))")
				return
			}

			do {

				//let JSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)

				let livestream = try JSONDecoder().decode(LivestreamingResponse.self, from: data!)

				// we NEED to be doing this 1 second later because otherwise we will get a 429
				DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1, execute: {
					
					if livestream.IsLive {
						
						// we also need to know how much longer is left on the stream
						// so we need to call the polling route at least once
						// so that we can make sure the stream hasn't passed and the API failed to update mongo
						
						self.livestreamData = livestream
						
						self.pollForLiveData()
					}
					else {
						// maybe we can have an async thread here running that checks to see if every minute,
						// we are getting close to beginning a live stream? (thoughts)
					}
				})
			}
			catch let jsonError {
				print(jsonError)
			}
		}.resume()
	}
	
	func pollForLiveData() {
		
		let thing = "\(apiUrl)api/sermons/live/poll"
		let url = NSURL(string: thing)
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			
			// something went wrong here
			if error != nil {
				
				self.miscApiErrorText = "\(error!)"
				
				return
			}
			
			do {
				
				//let JSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
				
				let pollData = try JSONDecoder().decode(LivePollingResponse.self, from: data!)
				
				DispatchQueue.main.async {
					// transition to another view
					self.pollingData = pollData
					
					if pollData.IsLive ?? false {
						self.checkIfStreamIsActiveAsync()
					}
					else {
						self.livestreamButton.isEnabled = false
					}
				}
			}
			catch let jsonError {
				print(jsonError)
			}
		}.resume()
	}
	
	func checkIfStreamIsActiveAsync() {
		// do this every 30sec to cut down on the Client load &
		// we might want to dynamically generate this timer in the future, but I like this
		
		self.timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(checkIfStreamExpired), userInfo: nil, repeats: true)
		
		// we need to check every 30 seconds but we should check right now
		checkIfStreamExpired()
		
		/*
			NOTE TO SELF:
		
			This code block and everything contained therein is going to end up becoming
			somewhat of a memory leak. This method will continue to be executed, even on
			other views. We should do what we can to limit the excess mem leakage.
		
			Perhaps when the view transitions to viewDidDissapear we can kill the timer,
			then when we transition back within viewWillAppear we can call the methods again
			and allow them to continue to execute. This will save us a TON of headache in the
			future with bugs related to this, plus it'll slowly eat away at the client's RSS.
		
		*/
	}
	
	@objc func checkIfStreamExpired() {
		let expireDateString = self.getExpirationDateString(expireDate: (self.pollingData?.StreamExpirationTime)!)
		
		if expireDateString == nil || expireDateString == "" {
			livestreamButton.isEnabled = false
			timer.invalidate()
		}
		else {
			let expireDate = checkExpire(expires: expireDateString!)
			
			if expireDate == nil {
				livestreamButton.isEnabled = false
				timer.invalidate()
			}
			else {
				livestreamButton.isEnabled = true
				expireTime = expireDate!
			}
		}
	}
	
	/// Returns a Date object where ONLY the TIME is to be used
	/// Returns null if the stream is no longer active (past the expire date)
	func getExpirationDateString(expireDate: String) -> String? {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		let date = dateFormatter.date(from: expireDate)
		
		// convert to the proper format
		let dateToStringFormatter = DateFormatter()
		dateToStringFormatter.dateFormat = "HH:mm:ss"
		dateToStringFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateToStringFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		let expireDateString = dateToStringFormatter.string(from: date!)
		
		return expireDateString
	}
	
	private func checkExpire(expires: String) -> Date? {
		
		let now = Date()
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.dateFormat = "HH:mm:ss"
		let nowString = formatter.string(from: now)
		
		// now that both our times are strings we can convert them back to dates and compare
		let stringToDateFormatter = DateFormatter()
		stringToDateFormatter.dateFormat = "HH:mm:ss"
		stringToDateFormatter.locale = Locale(identifier: "en_US_POSIX")
		stringToDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		
		let nowDate = formatter.date(from: nowString) ?? Date()
		let expireDate = stringToDateFormatter.date(from: expires) ?? Date()
		let _ = Double(TimeZone.current.secondsFromGMT(for: nowDate))
		
		// we use the entire Date string here so that we are 100% sure that now
		// is past whatever time the time should be, since we sanitize the dates
		if expireDate < nowDate {
			return nil
		}
		else {
			return expireDate
		}
	}
	
	// TODO: Make this a global extension method so it can be used all over
	func composeEmail() {
		
		// lets not create a fild on the user's device if they can't even send us an email
		if MFMailComposeViewController.canSendMail() {
			
			// vars to add to the file
			var date = ""
			let stringFromDate = Date().iso8601    // "2017-03-22T13:22:13.933Z"
			if let dateFromString = stringFromDate.dateFromISO8601 {
				date = dateFromString.iso8601      // "2017-03-22T13:22:13.933Z"
			}
			
			// get info about the app on the device
			let buldleDict = Bundle.main.infoDictionary!
			let buildNum = buldleDict["CFBundleVersion"] as? String ?? ""
			let version = buldleDict["CFBundleShortVersionString"] as? String ?? ""
			
			let uuid = UUID().uuidString.suffix(8)
			
			// Save data to file
			let fileName = "\(uuid.suffix(3)).log"
			let documentDirURL = try! FileManager.default.url(for: .documentDirectory,
															  in: .userDomainMask,
															  appropriateFor: nil,
															  create: true)
			
			let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
			
			
			let year = Calendar.current.component(.year, from: Date())
			let writeString = "PLEASE DO NOT MODIFY THE CONTENTS OF THIS FILE\n" +
				"\n©\(year) Thrive Community Church. All information collected is used solely for product development and is never sold.\n" +
				"\n\nDevice Information" +
				"\nDevice:  \(UIDevice.current.modelName)" +
				"\nCurrent Time: \(date)" +
				"\niOS: \(UIDevice.current.systemVersion)" +
				"\n\nApplication Information" +
				"\nVersion: \(version)" +
				"\nBuild #: \(buildNum)" +
			    "\nFeedback ID: \(uuid)" +
				"\n\nIssue Details\n" +
			"Error Stacktrace: \n\n\(miscApiErrorText ?? "FATL ERR: UNABLE TO PARSE API ERROR!")"
			
			
			do {
				// Write to the file
				try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
				
				let composeVC = MFMailComposeViewController()
				
				composeVC.mailComposeDelegate = self
				composeVC.setToRecipients(["wyatt@thrive-fl.org"])
				composeVC.setSubject("Thrive iOS - ID: \(uuid)")
				
				if let fileData = NSData(contentsOfFile: fileURL.path) {
					composeVC.addAttachmentData(fileData as Data,
												mimeType: "text/txt",
												fileName: "\(uuid).log")
				}
				self.present(composeVC, animated: true, completion: nil)
				
			} catch let error as NSError {
				print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
				
				self.displayAlertForAction()
			}
		}
		else {
			self.displayAlertForAction()
		}
	}
	
	//Standard Mail compose controller code
	func mailComposeController(_ controller: MFMailComposeViewController,
							   didFinishWith result: MFMailComposeResult,
							   error: Error?) {
		
		switch result.rawValue {
		case MFMailComposeResult.cancelled.rawValue:
			print("Cancelled")
			
		case MFMailComposeResult.saved.rawValue:
			print("Saved")
			
		case MFMailComposeResult.sent.rawValue:
			// they sent us an email so hopefully we can fix it
			self.retryCounter = 0
			self.retryLimited = false
			print("Sent")
			
		case MFMailComposeResult.failed.rawValue:
			print("Error: \(String(describing: error?.localizedDescription))")
			
		default:
			break
		}
		
		self.dismiss(animated: true, completion: nil)
	}
	
	func enableErrorViews (status: Network.Status) {
		
		self.disableLoadingScreen()
		
		if status == .unreachable {
			// if they are offline update the message and inform them that they
			// will be unable to use services
			self.apiErrorMessage.text = "You are currently offline." +
			"\n\nTo stream sermons, enable internet access and tap the button below."
			self.retryButton.setTitle("I'm Online", for: .normal)
			self.retryButton.removeTarget(nil, action: nil, for: .allEvents)
			self.retryButton.addTarget(self, action: #selector(testOnlineAndResetViews), for: .touchUpInside)
		}
		else {
			apiErrorMessage.text = "An error ocurred while loading the content.\n\n" +
				"Check your internet connection and try again. If the issue persists send " +
			"us an email at \nwyatt@thrive-fl.org."
			self.retryButton.setTitle("Retry?", for: .normal)
			self.retryButton.removeTarget(nil, action: nil, for: .allEvents)
			self.retryButton.addTarget(self, action: #selector(retryPageLoad), for: .touchUpInside)
		}
		
		self.apiErrorMessage.isHidden = false
		self.backgroundView.isHidden = false
		self.retryButton.isHidden = false
	}
	
	func resetErrorViews() {
		self.apiErrorMessage.isHidden = true
		self.backgroundView.isHidden = true
		self.retryButton.isHidden = true
		
		self.enableLoadingScreen()
	}
	
	func enableLoadingScreen() {
		self.spinner.isHidden = false
		self.spinner.startAnimating()
	}
	
	func disableLoadingScreen() {
		self.spinner.isHidden = true
		self.spinner.stopAnimating()
		self.isLoading = false
	}
	
	func presentErrorAlert() {
		
		self.disableLoadingScreen()
		
		let alert = UIAlertController(title: "Having Issues?",
									  message: "Send us an email and let us know what your issue is.",
									  preferredStyle: .alert)
		
		let emailAlert = UIAlertAction(title: "Email Us", style: .default) { (alert) in
			self.composeEmail()
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		alert.addAction(emailAlert)
		alert.addAction(cancelAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	func checkIfApiResponseIsActive() {
		
		if self.sermonSeries.count > 1 {
			
			// Looks like everything is back to working
			self.resetErrorViews()
			self.fetchLiveStream()
			self.retryCounter = 0
			self.retryLimited = false
		}
	}
	
	func checkConnectivity() {
		// check status
		guard let status = Network.reachability?.status else { return }
		self.internetConnectionStatus = status
		
		// override this on the Simulator and that way we can still develop things
		if UIDevice.current.modelName == "Simulator" {
			self.internetConnectionStatus = .wifi
		}
	}
	
	@objc func testOnlineAndResetViews() {
		
		checkConnectivity()
		
		if self.internetConnectionStatus != .unreachable {
			
			self.enableLoadingScreen()
			
			// call the API and determine if the user is online
			self.fetchAllSermons(isReset: true)
			self.fetchLiveStream()
		}
	}
	
	@objc func refreshView() {
		self.collectionView?.reloadData()
	}
	
	func retrieveRecentlyPlayed() {
		
		// get the recently played sermon messages
		let decoded = UserDefaults.standard.object(forKey: ApplicationVariables.RecentlyPlayed) as? Data
		
		if decoded != nil {	
			self.recentlyPlayedButton.isEnabled = true
			self.playedMessage = true
		}
		else {
			self.recentlyPlayedButton.isEnabled = false
			self.playedMessage = false
		}
	}
	
	func presentOnboarding() {
		
		// Set the CollectionViewController to be visible from when the application starts
		// A concrete layout object that organizes items into a grid with optional header and footer views for each section.
		let viewLayout = UICollectionViewFlowLayout()
		viewLayout.scrollDirection = .horizontal
		let swipingController = OnboardingController(collectionViewLayout: viewLayout)
		
		// do not load the view if the user has already completed it
		let completedOB = swipingController.loadAndCheckOnboarding()
		if !completedOB {
			
			Analytics.logEvent(AnalyticsEventTutorialBegin, parameters: [
				AnalyticsParameterItemID: "id-Onboarding",
				AnalyticsParameterItemName: "Onboarding-init",
				AnalyticsParameterContentType: "cont"
			])
			
			self.present(swipingController, animated: true, completion: nil)
		}
	}
}
