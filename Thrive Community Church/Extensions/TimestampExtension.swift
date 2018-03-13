//
//  TimestampExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 3/12/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

extension UIViewController {
	
	func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
		let objDateformat: DateFormatter = DateFormatter()
		objDateformat.dateFormat = "yyyy-MM-dd"
		let strTime: String = objDateformat.string(from: dateToConvert as Date)
		let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
		let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
		let strTimeStamp: String = "\(milliseconds)"
		return strTimeStamp
	}
}
