//
//  ConfigSetting.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 6/28/20.
//  Copyright © 2020 Thrive Community Church. All rights reserved.
//

import UIKit

class ConfigSetting: NSObject, Decodable, NSCoding, NSSecureCoding {
    
    public static var supportsSecureCoding: Bool = true
    
	var `Type`: ConfigType
	var Key: String?
	var Value: String?
	
	required convenience public init(coder aDecoder: NSCoder) {
		let type = ConfigType(rawValue: aDecoder.decodeObject(forKey: "Type") as! String)!
		let key = aDecoder.decodeObject(forKey: "Key") as! String?
		let value = aDecoder.decodeObject(forKey: "Value") as! String?
		
		self.init(key: key, value: value, type: type)
	}
	
	public func encode(with aCoder: NSCoder) {
		aCoder.encode(Type.rawValue, forKey: "Type")
		aCoder.encode(Key, forKey: "Key")
		aCoder.encode(Value, forKey: "Value")
	}
	
	init(key: String?, value: String?, type: ConfigType) {
		self.`Type` = type
		self.Key = key
		self.Value = value
	}
	
}
