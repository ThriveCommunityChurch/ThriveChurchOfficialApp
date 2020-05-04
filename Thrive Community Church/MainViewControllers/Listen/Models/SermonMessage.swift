//
//  SermonMessage.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/28/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

public class SermonMessage: NSObject, Decodable, NSCoding {
	
	var AudioUrl: String?
	var AudioDuration: Double?
	var AudioFileSize: Double?
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
	
	/// DEPRECATED: Physical Size of the downloaded file, we can report this to the user
	var downloadSizeMB: Double?
	
	// TODO: Move this to FileManager
	/// Store byte representations of Images since these would need to be stored with FileManager otherwise
	var seriesArt: Data?
	
	/// The timestamp when this message was played
	var previouslyPlayed: Double?
	
	/// Friendly name of the sermon series
	var seriesTitle: String?
	
	init(audio: String?, duration: Double, video: String?, psg: String, spkr: String, name: String,
		 date: String, id: String, wkNum: Int, downloaded: Double?, localURI: String?, size: Double?,
		 seriesArt: Data?, played: Double?, seriesTitle: String?, audioFileSize: Double?) {
		self.AudioUrl = audio
		self.AudioDuration = duration
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
		self.seriesArt = seriesArt
		self.previouslyPlayed = played
		self.seriesTitle = seriesTitle
		self.AudioFileSize = audioFileSize
	}
	
	required convenience public init(coder aDecoder: NSCoder) {
		let audio = aDecoder.decodeObject(forKey: "AudioUrl") as! String?
		let duration = aDecoder.decodeObject(forKey: "AudioDuration") as! Double?
		let fileSize = aDecoder.decodeObject(forKey: "AudioFileSize") as! Double?
		let video = aDecoder.decodeObject(forKey: "VideoUrl") as! String?
		let psg = aDecoder.decodeObject(forKey: "PassageRef") as! String
		let spkr = aDecoder.decodeObject(forKey: "Speaker") as! String
		let name = aDecoder.decodeObject(forKey: "Title") as! String
		let date = aDecoder.decodeObject(forKey: "Date") as! String
		let id = aDecoder.decodeObject(forKey: "MessageId") as! String
		let wkNum = aDecoder.decodeObject(forKey: "WeekNum") as! Int?
		let downloaded = aDecoder.decodeObject(forKey: "DownloadedOn") as! Double?
		let localURI = aDecoder.decodeObject(forKey: "LocalAudioURI") as! String?
		let seriesTitle = aDecoder.decodeObject(forKey: "seriesTitle") as! String?
		let size = aDecoder.decodeObject(forKey: "downloadSizeMB") as! Double?
		let played = aDecoder.decodeObject(forKey: "previouslyPlayed") as! Double?
		let art = aDecoder.decodeObject(forKey: "seriesArt") as! Data?
		
		self.init(audio: audio, duration: duration ?? 0.0, video: video, psg: psg, spkr: spkr, name: name,
				  date: date, id: id, wkNum: wkNum ?? 0, downloaded: downloaded,
				  localURI: localURI, size: size, seriesArt: art, played: played,
				  seriesTitle: seriesTitle, audioFileSize: fileSize)
	}
	
	public func encode(with aCoder: NSCoder) {
		aCoder.encode(AudioUrl, forKey: "AudioUrl")
		aCoder.encode(AudioDuration, forKey: "AudioDuration")
		aCoder.encode(VideoUrl, forKey: "VideoUrl")
		aCoder.encode(PassageRef, forKey: "PassageRef")
		aCoder.encode(Speaker, forKey: "Speaker")
		aCoder.encode(Title, forKey: "Title")
		aCoder.encode(Date, forKey: "Date")
		aCoder.encode(MessageId, forKey: "MessageId")
		aCoder.encode(WeekNum, forKey: "WeekNum")
		aCoder.encode(DownloadedOn, forKey: "DownloadedOn")
		aCoder.encode(LocalAudioURI, forKey: "LocalAudioURI")
		aCoder.encode(downloadSizeMB, forKey: "downloadSizeMB")
		aCoder.encode(seriesArt, forKey: "seriesArt")
		aCoder.encode(previouslyPlayed, forKey: "previouslyPlayed")
		aCoder.encode(seriesTitle, forKey: "seriesTitle")
		aCoder.encode(AudioFileSize, forKey: "AudioFileSize")
	}
}
