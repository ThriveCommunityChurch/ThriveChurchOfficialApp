//
//  StringExtensions.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/28/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

extension String {
	
	func FormatDateFromISO8601ForUI() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		let date = dateFormatter.date(from: self)
		
		// since we may not be able to make a deep copy of the object, we should
		// just return what is requested because it's probably already formatted
		if date == nil {
			return self
		}
		
		let dateToStringFormatter = DateFormatter()
		dateToStringFormatter.dateFormat = "M.d.yy"
		dateToStringFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		let dateString = dateToStringFormatter.string(from: date!)
		
		return dateString
	}
}
