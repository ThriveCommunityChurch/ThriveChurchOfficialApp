//
//  LivestreamingResponse.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/28/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class LivestreamingResponse: NSObject, Decodable {
	var IsLive: Bool = false
	var VideoUrl: String?
	var Title: String?
	var SpecialEventTimes: String?
	var IsSpecialEvent: Bool = false
	var NextLive: String?
}
