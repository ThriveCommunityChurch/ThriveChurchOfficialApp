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
		var apiDomain = "nil"
		
		// contact the API on the address we have cached
		if let loadedData = UserDefaults.standard.string(forKey: ApplicationVariables.ApiCacheKey) {
			
			apiDomain = loadedData
		}
		
		// make our GET request
		
		//create the url with NSURL
		let url = URL(string: "\(apiDomain)/api/sermons")
		
		return sermons
	}
}
