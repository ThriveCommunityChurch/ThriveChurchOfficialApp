//
//  ImageCache.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/31/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
	public static let sharedInstance = ImageCache()
	
	private var cache: NSCache<NSString, UIImage>?
	
	public func initialize() {
		
		cache = NSCache<NSString, UIImage>()
	}
	
	public func addImagesToCache(imageData: [String: UIImage]) {
		
		if cache == nil {
			initialize()
		}
		
		for i in imageData {
			cache?.setObject(i.value, forKey: i.key as NSString)
		}
	}
	
	public func getImagesForKey(rssUrl: String) -> UIImage? {
		let image = cache?.object(forKey: rssUrl as NSString)
		// return nil if we don't find it
		return image
	}
}
