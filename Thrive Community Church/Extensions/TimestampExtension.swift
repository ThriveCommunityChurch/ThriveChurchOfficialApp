//
//  TimestampExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 3/12/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

extension Formatter {
	static let iso8601: DateFormatter = {
		let formatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.timeZone = TimeZone(secondsFromGMT: -18000)
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
		return formatter
	}()
}
extension Date {
	var iso8601: String {
		return Formatter.iso8601.string(from: self)
	}
}

extension String {
	var dateFromISO8601: Date? {
		return Formatter.iso8601.date(from: self)
	}
	
}
