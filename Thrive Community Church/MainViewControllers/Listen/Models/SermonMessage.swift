//
//  SermonMessage.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/28/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

class SermonMessage: NSObject, Decodable, NSCoding {
	
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
	
	/// Physical Size of the downloaded file, we can report this to the user
	var downloadSizeMB: Double?
	
	init(audio: String?, video: String?, psg: String, spkr: String, name: String,
		 date: String, id: String, wkNum: Int, downloaded: Double?, localURI: String?, size: Double?) {
		self.AudioUrl = audio
		self.VideoUrl = video
		self.PassageRef = psg
		self.Speaker = spkr
		self.Title = name
		self.Date = date
		self.MessageId = id
		self.WeekNum = wkNum
		self.DownloadedOn = downloaded
		self.LocalAudioURI = localURI
		self.downloadSizeMB = size
	}
	
	required convenience init(coder aDecoder: NSCoder) {
		let audio = aDecoder.decodeObject(forKey: "AudioUrl") as! String?
		let video = aDecoder.decodeObject(forKey: "VideoUrl") as! String?
		let psg = aDecoder.decodeObject(forKey: "PassageRef") as! String
		let spkr = aDecoder.decodeObject(forKey: "Speaker") as! String
		let name = aDecoder.decodeObject(forKey: "Title") as! String
		let date = aDecoder.decodeObject(forKey: "Date") as! String
		let id = aDecoder.decodeObject(forKey: "MessageId") as! String
		let wkNum = aDecoder.decodeObject(forKey: "WeekNum") as! Int?
		let downloaded = aDecoder.decodeObject(forKey: "DownloadedOn") as! Double?
		let localURI = aDecoder.decodeObject(forKey: "LocalAudioURI") as! String?
		let size = aDecoder.decodeObject(forKey: "downloadSizeMB") as! Double?
		self.init(audio: audio, video: video, psg: psg, spkr: spkr, name: name,
				  date: date, id: id, wkNum: wkNum ?? 0, downloaded: downloaded,
				  localURI: localURI, size: size)
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(AudioUrl, forKey: "AudioUrl")
		aCoder.encode(VideoUrl, forKey: "VideoUrl")
		aCoder.encode(PassageRef, forKey: "PassageRef")
		aCoder.encode(Speaker, forKey: "Speaker")
		aCoder.encode(Title, forKey: "Title")
		aCoder.encode(Date, forKey: "Date")
		aCoder.encode(MessageId, forKey: "MessageId")
		aCoder.encode(WeekNum, forKey: "WeekNum")
		aCoder.encode(DownloadedOn, forKey: "DownloadedOn")
		aCoder.encode(LocalAudioURI, forKey: "LocalAudioURI")
		aCoder.encode(LocalAudioURI, forKey: "downloadSizeMB")
	}
}
