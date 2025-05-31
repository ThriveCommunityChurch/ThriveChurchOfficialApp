//
//  ConfigurationSetting.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 6/27/20.
//  Copyright © 2020 Thrive Community Church. All rights reserved.
//

import UIKit

class ConfigurationSettingResponse: NSObject, Decodable, NSCoding, NSSecureCoding {

    public static var supportsSecureCoding: Bool = true
	var `Type`: String?
	var Key: String?
	var Value: String?

	required convenience public init(coder aDecoder: NSCoder) {
		let type = aDecoder.decodeObject(of: NSString.self, forKey: "Type") as String?
		let key = aDecoder.decodeObject(of: NSString.self, forKey: "Key") as String?
		let value = aDecoder.decodeObject(of: NSString.self, forKey: "Value") as String?

		self.init(key: key, value: value, typeName: type)
	}

	public func encode(with aCoder: NSCoder) {
		aCoder.encode(Type, forKey: "Type")
		aCoder.encode(Key, forKey: "Key")
		aCoder.encode(Value, forKey: "Value")
	}

	init(key: String?, value: String?, typeName: String?) {
		self.`Type` = typeName
		self.Key = key
		self.Value = value
	}

}
