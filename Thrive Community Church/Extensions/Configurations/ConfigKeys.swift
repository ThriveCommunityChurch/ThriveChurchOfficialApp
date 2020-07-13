//
//  ConfigKeys.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 6/28/20.
//  Copyright © 2020 Thrive Community Church. All rights reserved.
//

import Foundation

class ConfigKeys {
	
	public static let shared = ConfigKeys()

	var Live: String = "Live_URL"
	var EmailMain: String = "Email_Main"
	var PhoneMain: String = "Phone_Main"
	var SmallGroup: String = "SmallGroup_URL"
	var AddressMain: String = "Address_Main"
	var Serve: String = "Serve_URL"
	var ImNew: String = "ImNew_URL"
	var Give: String = "Give_URL"
	var FB_Social: String = "FB_Social_URL"
	var TW_Social: String = "TW_Social_URL"
	var IG_Social: String = "IG_Social_URL"
	var Website: String = "Website_URL"
	var Team: String = "Team_URL"
	//var LocationName: String = "Location_Name"
	var FBPageID: String = "FB_PageId"
	var TWUsername: String = "TW_uName"
	var IGUSername: String = "IG_uName"
	
	public func GetAllKeys() -> [String] {
        var s = [String]()
		
		for c in Mirror(reflecting: self).children {
			if let name = c.value as? String {
                s.append(name)
            }
        }
        return s
    }
}
