//
//  PageInfo.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 1/25/19.
//  Copyright © 2019 Thrive Community Church. All rights reserved.
//

import Foundation

struct PageInfo: Decodable {
	let PageNumber: Int
	let TotalPageCount: Int
	let TotalRecordCount: Int
}
