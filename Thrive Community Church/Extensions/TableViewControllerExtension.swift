//
//  TableViewControllerExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 6/21/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit


extension UITableViewController {
	
	// after some long thinking I was able to determine that I belive this
	// is the most efficient way to determine the URL for a given passage at an index
	// this array containing only the slugs will help memory (since it contains only 3 letters,
	// and will increase performance)
	
	// this is also on-demand in that this will only allocate memory for this retreival
	// when the page is loading. Once it's loaded, it will be stored in memory
	// If we stored this in memory at the beginning it would be much more wasteful
	// Also an enum (I don't believe) will contain & return what we want. We want to
	// use the index of the tableView cell and then grab the URL from that
	
	func getUrlforTraditionalBookOrder() -> [String] {
		
		let tradLinkArr: [String] = [
			"gen",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
		]
		
		return tradLinkArr
	}
	
	func getUrlforAlphabeticalBookOrder() -> [String] {
		
		let alphLinkArr: [String] = [
			"1jn",
			"2ch",
			"2co",
			"2ch",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			]
		
		return alphLinkArr
	}
	
}
