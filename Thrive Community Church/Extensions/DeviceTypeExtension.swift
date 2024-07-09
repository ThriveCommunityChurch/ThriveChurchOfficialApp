//
//  DeviceTypeExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 3/12/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

public extension UIDevice {
	
	var modelName: String {
		var systemInfo = utsname()
		uname(&systemInfo)
		
		let machineMirror = Mirror(reflecting: systemInfo.machine)
		
		let identifier = machineMirror.children.reduce("") { identifier, element in
			guard let value = element.value as? Int8, value != 0 else { return identifier }
			return identifier + String(UnicodeScalar(UInt8(value)))
		}
		
		switch identifier {
		case "i386", "x86_64":                          return "Simulator"
		default:                                        return identifier
		}
	}
}
