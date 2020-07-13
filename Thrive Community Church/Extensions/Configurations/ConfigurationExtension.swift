//
//  ConfigurationExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 6/27/20.
//  Copyright © 2020 Thrive Community Church. All rights reserved.
//

import Foundation

class ConfigurationExtension {
	
	public static func GetConfigValue(key: String, completion: @escaping (ConfigurationSettingResponse) -> Void) {
		
		var apiUrl: String = ""
		
		// contact the API on the address we have cached
		if let loadedData = UserDefaults.standard.string(forKey: ApplicationVariables.ApiCacheKey) {
			
			let apiDomain = loadedData
			apiUrl = "http://\(apiDomain)/"
		}
		
		let url = NSURL(string: "\(apiUrl)api/config/?setting=\(key)")
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			
			// something went wrong here
			if error != nil {
				print(error!)
				
				return
			}
			
			do {
				let config = try JSONDecoder().decode(ConfigurationSettingResponse.self,
															 from: data!)
				
				// before we can place objects into Defaults they have to be encoded
				let encodedConfig: Data = NSKeyedArchiver.archivedData(withRootObject: config)
				
				UserDefaults.standard.set(encodedConfig, forKey: key)
				UserDefaults.standard.synchronize()
				
				completion(config)
			}
			catch let jsonError {
				print(jsonError)
			}
		}.resume()
	}
	
	public static func LoadConfigs() {
		
		var apiUrl: String = ""
		
		// contact the API on the address we have cached
		if let loadedData = UserDefaults.standard.string(forKey: ApplicationVariables.ApiCacheKey) {
			
			let apiDomain = loadedData
			apiUrl = "http://\(apiDomain)/"
		}
		
		let keys: [String] = ConfigKeys().GetAllKeys()
		var query: String = ""

		for key in keys {
			query += "keys=\(key)&"
		}
		
		query = String(query.dropLast())
		
		let url = NSURL(string: "\(apiUrl)api/config/list/?\(query)")
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			
			// something went wrong here
			if error != nil {
				print(error!)
				
				return
			}
			
			do {
				
				let configs = try JSONDecoder().decode(ConfigsCollection.self, from: data!)
					
				let iterate = configs.Configs?.count ?? 1
				var configsList = [ConfigSetting]()
				
				for i in 0...iterate - 1 {
					
					let config = configs.Configs![i]
					
					let enumValue = try ConfigType(from: config.Type!.self)
					let localConfig = ConfigSetting(key: config.Key, value: config.Value, type: enumValue)
					
					// before we can place objects into Defaults they have to be encoded
					let encodedConfig: Data = NSKeyedArchiver.archivedData(withRootObject: localConfig)

					print(config.Key!)
					UserDefaults.standard.set(encodedConfig, forKey: config.Key!)
					UserDefaults.standard.synchronize()

					configsList.append(localConfig)
				}
				
			}
			catch let jsonError {
				print(jsonError)
			}
			
		}.resume()
	}
	
}
