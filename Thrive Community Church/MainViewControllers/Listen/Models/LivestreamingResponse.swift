//
//  LivestreamingResponse.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/28/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit
struct LivestreamingResponse: Decodable {
	var IsLive: Bool = false
	var VideoUrl: String?
	var Title: String?
	var SpecialEventTimes: String?
	var IsSpecialEvent: Bool = false
}
