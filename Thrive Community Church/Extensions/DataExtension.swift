//
//  DataExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 1/16/19.
//  Copyright © 2019 Thrive Community Church. All rights reserved.
//

import UIKit

// Use this to convert between images and data
extension Data {
	var uiImage: UIImage? {
		return UIImage(data: self)
	}
}
