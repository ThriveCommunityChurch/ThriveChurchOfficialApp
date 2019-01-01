//
//  LivePollingResponse.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/29/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

struct LivePollingResponse: Decodable {
	var StreamExpirationTime: String
	var IsLive: Bool
}
