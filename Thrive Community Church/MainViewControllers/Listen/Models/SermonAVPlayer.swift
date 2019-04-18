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
import MediaPlayer

class SermonAVPlayer: NSObject {
	
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
	private var progressTimer: Timer? = nil
	
	/// Flag for if this currently playing audio has been downloaded
	private var isDownloaded: Bool = false
	
	// MARK: - Init
	
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
		
		// we need to register the player object with the Control Center so that
		// a user can pause and play the audio with a swipe
		registerWithCommandCenter()
		
		DispatchQueue.main.async {
			self.registerDataForRecentlyPlayed()
		}
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
		
		// we need to register the player object with the Control Center so that
		// a user can pause and play the audio with a swipe
		registerWithCommandCenter()
		
		DispatchQueue.main.async {
			self.registerDataForRecentlyPlayed()
		}
	}
	
	// MARK: - Command Center Controls & Info
	
	// This is kinda thrown together, but surprizingly it works given the lack of docs on
	// https://developer.apple.com/documentation/mediaplayer/mpnowplayinginfocenter
	
	private func registerWithCommandCenter() {
		
		// init the progress timer, to set a 0.3s timer that checks to see when the playback starts
		self.progressTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.isDownloadFinished), userInfo: nil, repeats: true)
	}
	
	private func skipBackward(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
		guard event.command is MPSkipIntervalCommand else {
			return .noSuchContent
		}
		
		self.rewind()
		
		return .success
	}
	
	private func skipForward(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
		guard event.command is MPSkipIntervalCommand else {
			return .noSuchContent
		}
		
		self.fastForward()
		
		return .success
	}
	
	private func pausePlayback(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
		
		self.pause()
		
		return .success
	}
	
	private func continuePlayback(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
		self.play()
		
		return .success
	}
	
	private func fastForward() {
		guard let duration  = player?.currentItem?.duration else {
			return
		}
		let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
		let newTime = playerCurrentTime + 15
		
		if newTime < CMTimeGetSeconds(duration) {
			
			let time2: CMTime = CMTimeMake(Int64(newTime * 1000 as Float64), 1000)
			player?.seek(to: time2)
			
			self.reinitNowPlayingInfoCenter(currentTime: newTime, isPaused: false)
		}
	}
	
	private func rewind() {
		
		let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
		var newTime = playerCurrentTime - 15
		
		if newTime < 0 {
			newTime = 0
		}
		
		let time2: CMTime = CMTimeMake(Int64(newTime * 1000 as Float64), 1000)
		player?.seek(to: time2)
		
		self.reinitNowPlayingInfoCenter(currentTime: newTime, isPaused: false)
	}
	
	/// Use this method to generate the InfoCenter stuffs when the file is being downloaded
	@objc private func isDownloadFinished() {
		
		if self.player?.timeControlStatus == .waitingToPlayAtSpecifiedRate {
			// still downloading
			return
		}
		else {
			// ACTIVATING PLAYBACK
			self.progressTimer?.invalidate()
			self.progressTimer = nil
			
			// Show everything as we expect on the control center
			self.displayDataOnControlCenter()
		}
	}
	
	private func displayDataOnControlCenter() {
		let commandCenter = MPRemoteCommandCenter.shared()
		
		// register all the targets for each control event
		let playCommand = commandCenter.playCommand
		playCommand.isEnabled = true
		playCommand.addTarget(handler: continuePlayback)
		
		let pauseCommand = commandCenter.pauseCommand
		pauseCommand.isEnabled = true
		pauseCommand.addTarget(handler: pausePlayback)
		
		let skipBackwardCommand = commandCenter.skipBackwardCommand
		skipBackwardCommand.isEnabled = true
		skipBackwardCommand.addTarget(handler: skipBackward)
		skipBackwardCommand.preferredIntervals = [15]
		
		let skipForwardCommand = commandCenter.skipForwardCommand
		skipForwardCommand.isEnabled = true
		skipForwardCommand.addTarget(handler: skipForward)
		skipForwardCommand.preferredIntervals = [15]
		
		// Scrubbing support
		let changePositionCommand = commandCenter.changePlaybackPositionCommand
		changePositionCommand.isEnabled = true
		
		// this is some complex madness, but it works with scrubbing
		changePositionCommand.addTarget { [weak self] (remoteEvent) -> MPRemoteCommandHandlerStatus in
			
			guard let self = self else { return .commandFailed }
			
			if let player = self.player {
				let playerRate = player.rate
				
				if let event = remoteEvent as? MPChangePlaybackPositionCommandEvent {
					
					player.seek(to: CMTime(seconds: event.positionTime, preferredTimescale: CMTimeScale(1000)), completionHandler: { [weak self](success) in
						
						guard let self = self else {return}
						
						if success {
							self.player?.rate = playerRate
						}
					})
					
					return .success
				}
			}
			return .commandFailed
		}
		
		UIApplication.shared.beginReceivingRemoteControlEvents()
		
		let time = self.player?.currentItem?.currentTime().seconds
		self.reinitNowPlayingInfoCenter(currentTime: time ?? 0.0, isPaused: false)
		
		// enable the information to all come together in the command center
		do {
			try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
			
			do {
				try AVAudioSession.sharedInstance().setActive(true)
			} catch let error as NSError {
				print(error.localizedDescription)
				
			}
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	private func reinitNowPlayingInfoCenter(currentTime: Double, isPaused: Bool) {
		
		DispatchQueue.main.async {
			let nowPlaying = [
					MPMediaItemPropertyTitle: self.messageTitle,
					MPNowPlayingInfoPropertyPlaybackRate: isPaused ? NSNumber(value: 0.0) : NSNumber(value: 1.0),
					MPMediaItemPropertyArtist: self.speaker,
					MPMediaItemPropertyArtwork: MPMediaItemArtwork(boundsSize: self.sermonGraphic?.size ?? CGSize(width: 300, height: 300), requestHandler: { (size) -> UIImage in
						return self.sermonGraphic ?? UIImage(named: "App_Icon_Large")!
					}),
					MPMediaItemPropertyAlbumTitle: self.seriesTitle,
					MPMediaItemPropertyPlaybackDuration: self.message?.AudioDuration ?? 0.0,
					MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime
				] as [String : Any]
			
			MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlaying
		}
	}
	
	private func resetNowPlayingInfoCenter() {
		
		// remove all the control events
		let commandCenter = MPRemoteCommandCenter.shared()
		
		let playCommand = commandCenter.playCommand
		playCommand.isEnabled = false
		
		let pauseCommand = commandCenter.pauseCommand
		pauseCommand.isEnabled = false
		
		let skipBackwardCommand = commandCenter.skipBackwardCommand
		skipBackwardCommand.isEnabled = false
		
		let skipForwardCommand = commandCenter.skipForwardCommand
		skipForwardCommand.isEnabled = false
		
		// Scrubbing support
		let changePositionCommand = commandCenter.changePlaybackPositionCommand
		changePositionCommand.isEnabled = false
		
		// remove the now playing info
		MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
		
		// ignore control events
		UIApplication.shared.endReceivingRemoteControlEvents()
	}
	
	public func checkPlayingStatus() -> Bool {
		return self.isPlaying
	}
	
	public func checkPausedStatus() -> Bool {
		return self.isPaused
	}
	
	// MARK: - Playback Controls
	
	public func pause() {
		
		let currentTime = self.player?.currentTime().seconds
		self.reinitNowPlayingInfoCenter(currentTime: currentTime ?? 0.0, isPaused: true)
		
		self.player?.pause()
		self.isPlaying = false
		self.isPaused = true
	}
	
	public func play() {
		
		let currentTime = self.player?.currentTime().seconds
		self.reinitNowPlayingInfoCenter(currentTime: currentTime ?? 0.0, isPaused: false)
		
		self.player?.play()
		self.isPlaying = true
		self.isPaused = false
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
		
		self.resetNowPlayingInfoCenter()
	}
	
	private func registerData(sermonData: SermonSeries? = nil, selectedMessage: SermonMessage,
														seriesImage: UIImage) {
		
		self.seriesTitle = sermonData == nil ? (selectedMessage.seriesTitle ?? "") : sermonData?.Name ?? ""
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
		selectedMessage.seriesTitle = self.seriesTitle
		
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
	
	private func registerDataForRecentlyPlayed() {
		
		// reset the data
		recentlyPlayed = [SermonMessage]()
		
		// get the recently played sermon messages
		let decoded = UserDefaults.standard.object(forKey: ApplicationVariables.RecentlyPlayed) as? Data
		if decoded != nil {
			
			let decodedSermonMessages = NSKeyedUnarchiver.unarchiveObject(with: decoded ?? Data()) as! [SermonMessage]
			
			var count = decodedSermonMessages.count
			recentlyPlayed = decodedSermonMessages
			let msg = message!
			
			// set the timestamp for this message using ms since epoch
			msg.previouslyPlayed = Date().timeIntervalSince1970
			
			// if we have 9 or less, then we should register this one, because we will have 10
			// if we always insert at 0 we'll always have the most recent at the top
			if count <= 9 {
				count = self.removeMatchingMessages(msg: msg)
				recentlyPlayed?.insert(msg, at: 0)
			}
			else {
				
				// we need to move the one we have, so delete it wherever it's at
				count = self.removeMatchingMessages(msg: msg)
				
				// THEN we can insert at 0 and pop the one on the end
				recentlyPlayed?.remove(at: count - 1)
				recentlyPlayed?.insert(msg, at: 0)
			}
		}
		else {
			// we haven't found anything in UD so add something
			message?.previouslyPlayed = Date().timeIntervalSince1970
			recentlyPlayed?.insert(message!, at: 0)
		}
		
		// before we can place objects into Defaults they have to be encoded
		let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: recentlyPlayed ?? [SermonMessage]())
		
		// we have a reference to this message in the above Defaults array, so store everything
		UserDefaults.standard.set(encodedData, forKey: ApplicationVariables.RecentlyPlayed)
		UserDefaults.standard.synchronize()
		
		// once we are doen reset the data again to avoid memory leaks
		recentlyPlayed = nil
	}
	
	private func getUniqueIDsFromArrayOfObjects(events: [SermonMessage]) -> [String] {
		let eventIds = events.map { $0.MessageId}
		let idset = Set(eventIds)
		return Array(idset)
	}
	
	private func removeMatchingMessages(msg: SermonMessage) -> Int {
		
		// the Id index of the sermons here are in the same order
		let idArray = getUniqueIDsFromArrayOfObjects(events: recentlyPlayed!)
		
		if idArray.contains(msg.MessageId) {
			// remove all instances of the message we are playing
			recentlyPlayed?.removeAll(where: { (sermonMessage) -> Bool in
				sermonMessage.MessageId == msg.MessageId
			})
		}
		
		return recentlyPlayed?.count ?? 0
	}
	
	private func sortMessagesMostRecentDescending() {
		
		// we'll only ever have to sort 10 of these
		self.recentlyPlayed = self.recentlyPlayed?.sorted {
			// this Anonymous closure means is the one after the one we are looking at less than this one?
			// if so then it goes before us, otherwise we are first, since higher numbers should be on top
			$1.previouslyPlayed?.isLess(than: $0.previouslyPlayed ?? 0.0) ?? false
		}
	}
}
