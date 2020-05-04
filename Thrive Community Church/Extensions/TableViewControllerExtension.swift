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
	
	func getBibleSelectionMap() -> [String: Int] {
		
		let response: [String: Int] = [
			"gen": 50
		]
		
		return response
	}
	
	func getTraditionalBooksSorted() -> [String] {
		
		let sortedList: [String] = [
			"Genesis",
			"Exodus",
			"Leviticus",
			"Numbers",
			"Deuteronomy",
			"Joshua",
			"Judges",
			"Ruth",
			"1 Samuel",
			"2 Samuel",
			"1 Kings",
			"2 Kings",
			"1 Chronicles",
			"2 Chronicles",
			"Ezra",
			"Nehemiah",
			"Esther",
			"Job",
			"Psalms",
			"Proverbs",
			"Ecclesiastes",
			"The Song of Solomon",
			"Isaiah",
			"Jeremiah",
			"Lamentations",
			"Ezekiel",
			"Daniel",
			"Hosea",
			"Joel",
			"Amos",
			"Obadiah",
			"Jonah",
			"Micah",
			"Nahum",
			"Habakkuk",
			"Zephaniah",
			"Haggai",
			"Zechariah",
			"Malachi",
			"Matthew",
			"Mark",
			"Luke",
			"John",
			"Acts",
			"Romans",
			"1 Corinthians",
			"2 Corinthians",
			"Galatians",
			"Ephesians",
			"Philippians",
			"Colossians",
			"1 Thessalonians",
			"2 Thessalonians",
			"1 Timothy",
			"2 Timothy",
			"Titus",
			"Philemon",
			"Hebrews",
			"James",
			"1 Peter",
			"2 Peter",
			"1 John",
			"2 John",
			"3 John",
			"Jude",
			"Revelation"
		]
		
		return sortedList
	}
	
	func getAlphaBooksSorted() -> [String] {
		
		let sortedList: [String] = [
			"1 Chronicles",
			"1 Corinthians",
			"1 John",
			"1 Kings",
			"1 Peter",
			"1 Samuel",
			"1 Thessalonians",
			"1 Timothy",
			"2 Chronicles",
			"2 Corinthians",
			"2 John",
			"2 Kings",
			"2 Peter",
			"2 Samuel",
			"2 Thessalonians",
			"2 Timothy",
			"3 John",
			"Acts",
			"Amos",
			"Colossians",
			"Daniel",
			"Deuteronomy",
			"Ecclesiastes",
			"Ephesians",
			"Esther",
			"Exodus",
			"Ezekiel",
			"Ezra",
			"Galatians",
			"Genesis",
			"Habakkuk",
			"Haggai",
			"Hebrews",
			"Hosea",
			"Isaiah",
			"James",
			"Jeremiah",
			"Job",
			"Joel",
			"John",
			"Jonah",
			"Joshua",
			"Jude",
			"Judges",
			"Lamentations",
			"Leviticus",
			"Luke",
			"Malachi",
			"Mark",
			"Matthew",
			"Micah",
			"Nahum",
			"Nehemiah",
			"Numbers",
			"Obadiah",
			"Philemon",
			"Philippians",
			"Proverbs",
			"Psalms",
			"Revelation",
			"Romans",
			"Ruth",
			"The Song of Solomon",
			"Titus",
			"Zechariah",
			"Zephaniah"
		]
		
		return sortedList
	}
	
	
	func openYouVersionBiblePassage(link: String, title: String?) {
		
		// this will either open in the YouVersion app or in Safari
		UIApplication.shared.open(URL(string: link)!, options:[:], completionHandler: nil)
		
	}
}
