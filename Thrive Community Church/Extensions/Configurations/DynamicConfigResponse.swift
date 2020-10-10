//
//  DynamicConfigResponse.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/23/20.
//  Copyright © 2020 Thrive Community Church. All rights reserved.
//

import UIKit

class DynamicConfigResponse {
	var Setting: ConfigSetting?
	var Destination: UIViewController
	var CellTitle: String = ""
	
	required convenience public init(coder aDecoder: NSCoder) {
		let setting = aDecoder.decodeObject(forKey: "Setting") as? ConfigSetting
		let destination = aDecoder.decodeObject(forKey: "Destination") as! UIViewController
		let title = aDecoder.decodeObject(forKey: "Title") as? String ?? ""
		
		self.init(destination: destination, setting: setting, title: title)
	}
	
	public func encode(with aCoder: NSCoder) {
		aCoder.encode(Setting, forKey: "Setting")
		aCoder.encode(Destination, forKey: "Destination")
		aCoder.encode(CellTitle, forKey: "Title")
	}
	
	init(destination: UIViewController, setting: ConfigSetting? = nil, title: String = "") {
		self.Setting = setting
		self.Destination = destination
		self.CellTitle = title
	}
}
