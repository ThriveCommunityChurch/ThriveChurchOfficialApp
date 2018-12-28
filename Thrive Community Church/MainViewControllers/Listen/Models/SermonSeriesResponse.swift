//
//  SermonSeriesResponse.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/27/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

struct SermonSeries: Decodable {
	var StartDate: String
	var EndDate: String?
	//var Messages: [SermonMessages]
	var Name: String
	var Year: String
	var Slug: String
	var Thumbnail: String
	var ArtUrl: String
	var LastUpdated: String?
}
