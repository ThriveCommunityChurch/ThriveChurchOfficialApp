//
//  ListenCollectionViewControllerRepoExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/24/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import Foundation

extension ListenCollectionViewController {
	
	func GetAllSermonSeries() -> [SermonSeriesSummary] {
		let sermons = [SermonSeriesSummary]()
		
		// make our GET request
		
		//create the url with NSURL
		
		return sermons
	}
	
	func fetchAllSermons() {
		
		var apiDomain = "nil"
		
		// contact the API on the address we have cached
		if let loadedData = UserDefaults.standard.string(forKey: ApplicationVariables.ApiCacheKey) {
			
			apiDomain = loadedData
		}
		
		// iOS is picky about SSL
		
		let url = NSURL(string: "https://\(apiDomain)/api/sermons")
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			
			// something went wrong here
			if error != nil {
				print(error)
				
				return
			}
			
			
			let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
			print(str)
			
		}.resume()
	}
}
