//
//  LivePollingResponse.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/29/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class LivePollingResponse: NSObject, Decodable {
	var StreamExpirationTime: String?
	var IsLive: Bool?
}
