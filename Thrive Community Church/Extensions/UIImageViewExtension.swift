//
//  UIImageViewExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/27/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit
import Foundation

extension UIImageView {
	
	func loadImage(resourceUrl: String) {
		let url = NSURL(string: resourceUrl)
		
		image = nil
		
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			
			// something went wrong here
			if error != nil {
				print(error!)
				
				return
			}
			
			DispatchQueue.main.async {
				let image = UIImage(data: data!)
				self.image = image
				let imageDict = [resourceUrl: image ?? UIImage()]
				ImageCache.sharedInstance.addImagesToCache(imageData: imageDict)
			}
		}.resume()
	}
}
