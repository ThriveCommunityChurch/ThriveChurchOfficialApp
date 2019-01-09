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
}
