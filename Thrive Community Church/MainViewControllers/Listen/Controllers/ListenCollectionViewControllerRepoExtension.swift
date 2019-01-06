//
//  ListenCollectionViewControllerRepoExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/24/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

extension ListenCollectionViewController {
	
	// MARK: - ThriveChurchOfficialAPI Requests
	
	func fetchAllSermons() {
		// iOS is picky about SSL
		
		let url = NSURL(string: "\(apiUrl)api/sermons")
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			
			// something went wrong here
			if error != nil {
				print(error!)
				return
			}
			
			do {
				let summaries = try JSONDecoder().decode(SermonSeriesSummaryResponse.self, from: data!)
				
				// reset the array before we refill it
				self.sermonSeries = [SermonSeriesSummary]()
				
				for i in summaries.Summaries {
					self.sermonSeries.append(i)
				}
				
				DispatchQueue.main.async {
					self.collectionView?.reloadData()
				}
			}
			catch let jsonError {
				print(jsonError)
			}
		}.resume()
	}
	
	func getSermonsForId(seriesId: String, image: UIImage) {
		
		let thing = "\(apiUrl)api/sermons/series/\(seriesId)"
		let url = NSURL(string: thing)
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			
			// something went wrong here
			if error != nil {
				print(error!)
				return
			}
			
			do {
				
				//let JSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
				
				let series = try JSONDecoder().decode(SermonSeries.self, from: data!)
				
				DispatchQueue.main.async {
					// transition to another view
					
					let vc = SeriesViewController()
					vc.SermonSeries = series
					vc.seriesImage = image
					
					self.show(vc, sender: self)
				}
			}
			catch let jsonError {
				print(jsonError)
			}
		}.resume()
	}
	
	func fetchLiveStream() {

		let thing = "\(apiUrl)api/sermons/live/"
		let url = NSURL(string: thing)
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in

			// something went wrong here
			if error != nil {
				print(error!)
				return
			}

			do {

				//let JSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)

				let livestream = try JSONDecoder().decode(LivestreamingResponse.self, from: data!)

				DispatchQueue.main.async {
					// transition to another view
					print(livestream)
					
					if livestream.IsLive {
						self.livestreamButton.isEnabled = true
						
						// we also need to know how much longer is left on the stream
						// so we need to call the polling route at least once
						self.pollForLiveData()
					}
					else {
						// maybe we can have an async thread here running that checks to see if every minute,
						// we are getting close to beginning a live stream? (thoughts)
					}
				}
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
				print(error!)
				return
			}
			
			do {
				
				//let JSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
				
				let pollData = try JSONDecoder().decode(LivePollingResponse.self, from: data!)
				
				DispatchQueue.main.async {
					// transition to another view
					self.pollingData = pollData
					
					if pollData.IsLive {
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
		
		let nowDate = formatter.date(from: nowString)
		let expireDate = stringToDateFormatter.date(from: expires)
		
		if nowDate! > expireDate! {
			print("the stream is over")
			return nil
		}
		else {
			return expireDate!
		}
	}
}
