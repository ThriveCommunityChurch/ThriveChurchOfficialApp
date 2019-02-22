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
	private var isPaused: Bool = false
	private var seriesTitle: String = ""
	private var weekNum: Int = 0
	private var speaker: String = ""
	private var passageRef: String = ""
	private var messageTitle: String = ""
	private var sermonGraphic: UIImage? = nil
	private var messageDate: String = ""
	private var message: SermonMessage? = nil
	private var recentlyPlayed: [SermonMessage]?
	
	/// Flag for if this currently playing audio has been downloaded
	private var isDownloaded: Bool = false
	
	public func initUsingRssString(rssUrl: String, sermonData: SermonSeries? = nil,
								   selectedMessage: SermonMessage, seriesImage: UIImage) {
		
		if self.isPlaying {
			self.stop()
		}
		
		guard let url = URL(string: rssUrl) else { return }
		let playerItem = AVPlayerItem(url: url)
		self.player = AVPlayer(playerItem: playerItem)
		self.play()
		self.isPlaying = true
		
		self.registerData(sermonData: sermonData ?? nil, selectedMessage: selectedMessage, seriesImage: seriesImage)
		
		DispatchQueue.main.async(execute: {
			self.registerDateForRecentlyPlayed()
		})
	}
	
	public func initLocally(selectedMessage: SermonMessage) {
		
		if self.isPlaying {
			self.stop()
		}
		
		guard let url = URL(string: selectedMessage.LocalAudioURI ?? "") else { return }
		self.player = AVPlayer(url: url)
		self.play()
		self.isPlaying = true
		
		self.registerDataFromLocal(selectedMessage: selectedMessage)
		
		DispatchQueue.main.async {
			self.registerDateForRecentlyPlayed()
		}
	}
	
	public func pause() {
		self.player?.pause()
		self.isPlaying = false
		self.isPaused = true
	}
	
	public func play() {
		self.player?.play()
		self.isPlaying = true
		self.isPaused = false
	}
	
	public func checkPlayingStatus() -> Bool {
		return self.isPlaying
	}
	
	public func checkPausedStatus() -> Bool {
		return self.isPaused
	}
	
	public func stop() {
		self.player?.pause()
		self.player = nil
		self.isPlaying = false
		self.isPaused = false
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
	
	private func registerData(sermonData: SermonSeries? = nil, selectedMessage: SermonMessage,
														seriesImage: UIImage) {
		
		self.seriesTitle = sermonData?.Name ?? (selectedMessage.seriesTitle ?? "")
		self.passageRef = selectedMessage.PassageRef ?? ""
		self.messageTitle = selectedMessage.Title
		self.speaker = selectedMessage.Speaker
		self.weekNum = selectedMessage.WeekNum ?? 0
		self.sermonGraphic = seriesImage
		self.messageDate = selectedMessage.Date
		self.isDownloaded = selectedMessage.DownloadedOn != nil
		
		// load everything from the selected message and put it in the response one, we will use this
		// as the message object we store in the UserDefaults for it's MessageId
		selectedMessage.seriesArt = UIImagePNGRepresentation(seriesImage)
		message = selectedMessage
	}
	
	private func registerDataFromLocal(selectedMessage: SermonMessage) {
		
		self.passageRef = selectedMessage.PassageRef ?? ""
		self.messageTitle = selectedMessage.Title
		self.speaker = selectedMessage.Speaker
		self.weekNum = selectedMessage.WeekNum ?? 0
		self.sermonGraphic = selectedMessage.seriesArt?.uiImage
		self.messageDate = selectedMessage.Date
		self.isDownloaded = selectedMessage.DownloadedOn != nil
		
		// load everything from the selected message and put it in the response one, we will use this
		// as the message object we store in the UserDefaults for it's MessageId
		message = selectedMessage
	}

	public func getDataForPlayback() -> [String: Any]? {
				
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
	
	private func registerDateForRecentlyPlayed() {
		
		// reset the data
		recentlyPlayed = [SermonMessage]()
		
		// get the recently played sermon messages
		let decoded = UserDefaults.standard.object(forKey: ApplicationVariables.RecentlyPlayed) as? Data
		if decoded != nil {
			
			let decodedSermonMessages = NSKeyedUnarchiver.unarchiveObject(with: decoded ?? Data()) as! [SermonMessage]
			
			let count = decodedSermonMessages.count
			recentlyPlayed = decodedSermonMessages
			let msg = message!
			
			// set the timestamp for this message using ms since epoch
			msg.previouslyPlayed = Date().timeIntervalSince1970
			
			// if we have 9 or less, then we should register this one, because we will have 10
			if count <= 9 {
				findAndMoveRecentPlayedToEnd(msg: msg, isFull: false)
			}
			else {
				// otherwise we need to remove the one at the front and add the new one at the end
				// first however we need to check that this message is not already in the list
				findAndMoveRecentPlayedToEnd(msg: msg, isFull: true)
				
				recentlyPlayed?.remove(at: 0)
				recentlyPlayed?.append(message!)
			}
		}
		else {
			// we haven't found anything in UD so add something
			message?.previouslyPlayed = Date().timeIntervalSince1970
			recentlyPlayed?.append(message!)
		}
		
		// sort messages before we load anything on the UI
		sortMessagesMostRecentDescending()
		
		// before we can place objects into Defaults they have to be encoded
		let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: recentlyPlayed ?? [SermonMessage]())
		
		// we have a reference to this message in the above Defaults array, so store everything
		UserDefaults.standard.set(encodedData, forKey: ApplicationVariables.RecentlyPlayed)
		UserDefaults.standard.synchronize()
		
		// once we are doen reset the data again to avoid memory leaks
		recentlyPlayed = nil
	}
	
	private func findAndMoveRecentPlayedToEnd(msg: SermonMessage, isFull: Bool) {
		
		// the Id index of the sermons here are in the same order
		let idArray = getUniqueIDsFromArrayOfObjects(events: recentlyPlayed!)
		
		if idArray.contains(msg.MessageId) {
			// remove all instances of the message we are playing
			recentlyPlayed?.removeAll(where: { (sermonMessage) -> Bool in
				sermonMessage.MessageId == msg.MessageId
			})
		}
		
		if !isFull {
			recentlyPlayed?.append(msg)
		}
	}
	
	func getUniqueIDsFromArrayOfObjects(events: [SermonMessage]) -> [String] {
		let eventIds = events.map { $0.MessageId}
		let idset = Set(eventIds)
		return Array(idset)
	}
	
	func sortMessagesMostRecentDescending() {
		
		// we'll only ever have to sort 10 of these
		self.recentlyPlayed = self.recentlyPlayed?.sorted {
			// this Anonymous closure means is the one after the one we are looking at less than this one?
			// if so then it goes before us, otherwise we are first, since higher numbers should be on top
			$1.previouslyPlayed?.isLess(than: $0.previouslyPlayed ?? 0.0) ?? false
		}
	}
}

