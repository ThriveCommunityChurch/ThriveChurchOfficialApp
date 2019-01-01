//
//  SermonMessage.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/28/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

struct SermonMessage: Decodable {
	var AudioUrl: String?
	var VideoUrl: String?
	var PassageRef: String?
	var Speaker: String
	var Title: String
	var Date: String
	var MessageId: String
	var WeekNum: Int?
}
