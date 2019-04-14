//
//  DoubleExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 1/8/19.
//  Copyright © 2019 Thrive Community Church. All rights reserved.
//

import UIKit

extension Double {
	
	/// Rounds the double to decimal places value
	func rounded(toPlace: Int) -> Double {
		
		let divisor = pow(10.0, Double(toPlace))
		return (self * divisor).rounded() / divisor
	}
	
	/// converts the value to MB
	func toMB() -> Double {
		return (Double(self) / 1024 / 1024)
	}
	
	/// return a number of seconds into a number of hours minutes and seconds
	func secondsToHoursMinutesSeconds() -> (Double, Double, Double) {
		let (hr,  minf) = modf (self / 3600)
		let (min, secf) = modf (60 * minf)
		return (hr, min, 60 * secf)
	}
	
	/// return a duration in minutes or hours for the length of a number of seconds
	func formatDurationForUI(displayAsPositional: Bool = false) -> String? {
		
		let duration: TimeInterval = self // 2 minutes, 30 seconds
		
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = displayAsPositional ? .positional : .abbreviated
		formatter.allowedUnits = [ .minute, .second ]
		formatter.zeroFormattingBehavior = [ .pad ]
		
		let formattedDuration = formatter.string(from: duration)
		return formattedDuration
	}
}
