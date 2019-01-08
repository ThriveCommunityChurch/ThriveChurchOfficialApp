//
//  TableViewControllerExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 6/21/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit


extension UITableViewController {

	func getUrlforTraditionalBookOrder() -> [String] {
		
		let tradLinkArr: [String] = [
			"gen",
			"exo",
			"lev",
			"num",
			"deu",
			"jos",
			"jdg",
			"rut",
			"1sa",
			"2sa",
			"1ki",
			"2ki",
			"1ch",
			"2ch",
			"ezr",
			"neh",
			"est",
			"job",
			"psa",
			"pro",
			"ecc",
			"sng",
			"isa",
			"jer",
			"lam",
			"eze",
			"dan",
			"hos",
			"jol",
			"amo",
			"oba",
			"jon",
			"mic",
			"nah",
			"hab",
			"zep",
			"hag",
			"zec",
			"mal",
			"mat",
			"mar",
			"luk",
			"jhn",
			"act",
			"rom",
			"1co",
			"2co",
			"gal",
			"eph",
			"php",
			"col",
			"1th",
			"2th",
			"1ti",
			"2ti",
			"tit",
			"phm",
			"heb",
			"jam",
			"1pe",
			"2pe",
			"1jn",
			"2jn",
			"3jn",
			"jud",
			"rev"
		]
		
		return tradLinkArr
	}
	
	func getUrlforAlphabeticalBookOrder() -> [String] {
		
		let alphLinkArr: [String] = [
			"1ch",
			"1co",
			"1jn",
			"1ki",
			"1pe",
			"1sa",
			"1th",
			"1ti",
			"2ch",
			"2co",
			"2jn",
			"2ki",
			"2pe",
			"2sa",
			"2th",
			"2ti",
			"3jn",
			"act",
			"amo",
			"col",
			"dan",
			"deu",
			"ecc",
			"eph",
			"est",
			"exo",
			"ezk",
			"ezr",
			"gal",
			"gen",
			"hab",
			"hag",
			"heb",
			"hos",
			"isa",
			"jas",
			"jer",
			"job",
			"jol",
			"jhn",
			"jon",
			"jos",
			"jud",
			"jdg",
			"lam",
			"lev",
			"luk",
			"mal",
			"mar",
			"amt",
			"mic",
			"nah",
			"neh",
			"num",
			"oba",
			"phm",
			"php",
			"pro",
			"psa",
			"rev",
			"rom",
			"rut",
			"sng",
			"tit",
			"zec",
			"zep"
			]
		
		return alphLinkArr
	}
	
	func openVCAtSpecificURLForTable(link: String, title: String?) {
		
		let vc = OpenBiblePassageViewController()
		let passage = BiblePassage(url: link)
		vc.link = passage.url
		vc.navigationItem.title = title ?? ""
		navigationController?.show(vc, sender: self)
	}
	
}
