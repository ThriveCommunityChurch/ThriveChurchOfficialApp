//
//  DoubleExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 1/8/19.
//  Copyright © 2019 Thrive Community Church. All rights reserved.
//

import UIKit
import Foundation

extension Double {
	
	/// Rounds the double to decimal places value
	func rounded(toPlace: Int) -> Double {
		
		let divisor = pow(10.0, Double(toPlace))
		return (self * divisor).rounded() / divisor
	}
	
	/// Removes trailing zeros when you want 10 instead of 10.00 or 10.0
	func removeZerosFromEnd() -> String {
		let formatter = NumberFormatter()
		let number = NSNumber(value: self)
		formatter.minimumFractionDigits = 0
		formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
		return String(formatter.string(from: number) ?? "")
	}
	
	/// converts the value to MB
	func toMB() -> Double {
		return (Double(self) / 1024 / 1024)
	}
	
	/// return a duration in minutes or hours for the length of a number of seconds
	func formatDurationForUI(displayAsPositional: Bool = false) -> String? {
		
		let duration: TimeInterval = self // 2 minutes, 30 seconds
		
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = displayAsPositional ? .positional : .abbreviated
		formatter.allowedUnits = [ .minute, .second ]
		formatter.zeroFormattingBehavior = [ .pad ]
		
		var formattedDuration = formatter.string(from: duration)
		
		// we don't need to show 0s
		if !displayAsPositional {
			formattedDuration = formattedDuration?.replacingOccurrences(of: " 0s", with: "")
		}
		
		return formattedDuration
	}
}
