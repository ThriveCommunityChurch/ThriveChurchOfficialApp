//
//  Storage.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 1/8/19.
//  Copyright © 2019 Thrive Community Church. All rights reserved.
//

import Foundation

class Storage {
	
	static func getFreeSpace() -> Double {
		do {
			let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
			
			return ((attributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.doubleValue)!
		}
		catch {
			return 0
		}
	}
	
	static func getTotalSpace() -> Double {
		do {
			let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
			return ((attributes[FileAttributeKey.systemSize] as? NSNumber)?.doubleValue)!
		}
		catch {
			return 0
		}
	}
	
	static func getUsedSpace() -> Double
	{
		return getTotalSpace() - getFreeSpace()
	}
}

