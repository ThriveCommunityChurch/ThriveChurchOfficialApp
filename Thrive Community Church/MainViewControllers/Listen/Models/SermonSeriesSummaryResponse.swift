//
//  SermonSeriesSummaryResponse.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/27/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit
import Foundation

struct SermonSeriesSummaryResponse: Decodable {
	var Summaries: [SermonSeriesSummary]
}
