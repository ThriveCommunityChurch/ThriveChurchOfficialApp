//
//  SermonAVPlayer.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/29/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class SermonAVPlayer {
	public static let sharedInstance = SermonAVPlayer()
	
	private var player: AVPlayer?
	private var isPlaying: Bool = false
	private var seriesTitle: String = ""
	private var weekNum: Int = 0
	private var speaker: String = ""
	private var passageRef: String = ""
	private var messageTitle: String = ""
	private var sermonGraphic: UIImage? = nil
	private var messageDate: String = ""
	private var message: SermonMessage? = nil
	
	/// Flag for if this currently playing audio has been downloaded
	private var isDownloaded: Bool = false
	
	public func initUsingRssString(rssUrl: String, sermonData: SermonSeries,
								   selectedMessage: SermonMessage, seriesImage: UIImage) {
		
		player = AVPlayer()
		
		guard let url = URL(string: rssUrl) else { return }
		let playerItem = AVPlayerItem(url: url)
		self.player = AVPlayer(playerItem: playerItem)
		self.play()
		self.isPlaying = true
		
		self.registerData(sermonData: sermonData, selectedMessage: selectedMessage, seriesImage: seriesImage)
	}
	
	public func pause() {
		self.player?.pause()
		self.isPlaying = false
	}
	
	public func play() {
		self.player?.play()
		self.isPlaying = true
	}
	
	public func checkPlayingStatus() -> Bool {
		return self.isPlaying
	}
	
	public func stop() {
		self.player?.pause()
		self.player = nil
		self.isPlaying = false
		self.resetData()
	}
	
	private func resetData() {
		seriesTitle = ""
		weekNum = 0
		speaker = ""
		passageRef = ""
		messageTitle = ""
		sermonGraphic = nil
		messageDate = ""
	}
	
	private func registerData(sermonData: SermonSeries, selectedMessage: SermonMessage,
														seriesImage: UIImage) {
		
		self.seriesTitle = sermonData.Name
		self.passageRef = selectedMessage.PassageRef ?? ""
		self.messageTitle = selectedMessage.Title
		self.speaker = selectedMessage.Speaker
		self.weekNum = selectedMessage.WeekNum ?? 0
		self.sermonGraphic = seriesImage
		self.messageDate = selectedMessage.Date
		self.isDownloaded = selectedMessage.DownloadedOn != nil
		
		// load everything from the selected message and put it in the response one, we will use this
		// as the message object we store in the UserDefaults for it's MessageId
		message = selectedMessage
	}

	public func getDataForPlayback() -> [String: Any]? {
		
		if !self.isPlaying {
			return nil
		}
		
		// the nice thing about swift is that we can respond with a dictionary of
		// string to any type, meaning that a simple key lookup will give us whatever type the obj is
		let responseDict = ["seriesTitle": seriesTitle,
						"weekNum": weekNum,
						"speaker": speaker,
						"passageRef": passageRef,
						"messageTitle": messageTitle,
						"sermonGraphic": sermonGraphic as Any,
						"messageDate": messageDate,
						"isDownloaded": isDownloaded,
						"message": message as Any]
		
		return responseDict
	}
	
	public func getPlayer() -> AVPlayer {
		return self.player!
	}
}
