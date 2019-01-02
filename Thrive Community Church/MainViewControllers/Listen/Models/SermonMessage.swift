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
	
	/// Number representing the time since Epoch that this message was downloaded
	/// We will use these values to sort in descending order (most recent first)
	var DownloadedOn: Double?
	
	/// If a message has been saved to the device, we need to know where the audio file
	/// is stored on the device.
	var LocalAudioURI: String?
}
