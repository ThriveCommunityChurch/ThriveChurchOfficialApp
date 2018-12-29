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
//
//		let thing = "\(apiUrl)api/sermons/live/"
//		let url = NSURL(string: thing)
//		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
//
//			// something went wrong here
//			if error != nil {
//				print(error!)
//				return
//			}
//
//			do {
//
//				//let JSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
//
//				let series = try JSONDecoder().decode(LivestreamingResponse.self, from: data!)
//
//				DispatchQueue.main.async {
//					// transition to another view
//
//					let vc = SeriesViewController()
//					vc.SermonSeries = series
//					vc.seriesImage = image
//
//					self.show(vc, sender: self)
//				}
//			}
//			catch let jsonError {
//				print(jsonError)
//			}
//		}.resume()
	}
}
