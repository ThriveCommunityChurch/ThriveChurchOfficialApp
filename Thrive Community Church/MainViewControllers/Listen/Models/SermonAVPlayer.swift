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
	private var registered: Bool = false

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
			selectedMessage.registerDataForRecentlyPlayed(seriesImage: seriesImage)

			// Post notification that audio playback has started
			NotificationCenter.default.post(name: NSNotification.Name("AudioPlaybackStarted"), object: nil)
		}
	}

	public func initLocally(selectedMessage: SermonMessage) {

		if self.isPlaying {
			self.stop()
		}

		guard let localPath = selectedMessage.LocalAudioURI,
			  !localPath.isEmpty else {
			print("ERROR: LocalAudioURI is nil or empty for message: \(selectedMessage.MessageId)")
			return
		}

		// Handle both old format (URL string) and new format (file path)
		let url: URL
		if localPath.hasPrefix("file://") {
			// Old format: URL string - convert to URL directly
			guard let urlFromString = URL(string: localPath) else {
				print("ERROR: Invalid URL string in LocalAudioURI: \(localPath)")
				return
			}
			url = urlFromString
			print("Playing local file (old format) from: \(url.absoluteString)")
		} else {
			// New format: file path - create file URL
			url = URL(fileURLWithPath: localPath)
			print("Playing local file (new format) from: \(url.absoluteString)")
		}

		// Verify file exists before attempting playback
		if !FileManager.default.fileExists(atPath: url.path) {
			print("ERROR: Local audio file does not exist at path: \(url.path)")
			return
		}

		self.player = AVPlayer(url: url)
		self.play()
		self.isPlaying = true

		self.registerDataFromLocal(selectedMessage: selectedMessage)

		// we need to register the player object with the Control Center so that
		// a user can pause and play the audio with a swipe
		registerWithCommandCenter()

		DispatchQueue.main.async {
			selectedMessage.registerDataForRecentlyPlayed()

			// Post notification that audio playback has started
			NotificationCenter.default.post(name: NSNotification.Name("AudioPlaybackStarted"), object: nil)
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

			let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
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

		let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
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
		self.registered = true

		// Configure audio session respectfully - only when we're actually playing
		do {
			// Use .playback category with .mixWithOthers option to be more respectful
			// This allows other apps to resume their audio when we're not actively playing
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.allowBluetooth, .allowBluetoothA2DP])
			print("Audio session category set to playback with respectful options")

			do {
				try AVAudioSession.sharedInstance().setActive(true)
				print("Audio session activated for playback")
			} catch let error as NSError {
				print("Error activating audio session: \(error.localizedDescription)")
			}
		} catch let error as NSError {
			print("Error setting audio session category: \(error.localizedDescription)")
		}
	}

	private func reinitNowPlayingInfoCenter(currentTime: Double, isPaused: Bool) {

		DispatchQueue.main.async {
			let nowPlaying = [
					MPMediaItemPropertyTitle: self.messageTitle,
					MPNowPlayingInfoPropertyPlaybackRate: isPaused ? NSNumber(value: 0.0) : NSNumber(value: 1.0),
					MPMediaItemPropertyArtist: self.speaker,
					MPMediaItemPropertyArtwork:
						MPMediaItemArtwork(boundsSize: self.sermonGraphic?.size ?? CGSize(width: 300, height: 300), requestHandler: { (size) -> UIImage in
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

		// Deactivate audio session to allow other apps to reclaim audio
		do {
			try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
			print("Audio session deactivated - other apps can now resume audio")
		} catch let error as NSError {
			print("Error deactivating audio session: \(error.localizedDescription)")
		}

		self.registered = false
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

		// Optionally deactivate audio session when paused to allow other apps to play
		// We'll reactivate it when play is called again
		do {
			try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
			print("Audio session deactivated on pause - other apps can now play audio")
		} catch let error as NSError {
			print("Error deactivating audio session on pause: \(error.localizedDescription)")
		}
	}

	public func play() {

		// Reactivate audio session when resuming playback
		do {
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.allowBluetooth, .allowBluetoothA2DP])
			try AVAudioSession.sharedInstance().setActive(true)
			print("Audio session reactivated for playback")
		} catch let error as NSError {
			print("Error reactivating audio session: \(error.localizedDescription)")
		}

		self.player?.play()
		self.isPlaying = true
		self.isPaused = false

		if self.player != nil && registered {
			let currentTime = self.player?.currentTime().seconds
			self.reinitNowPlayingInfoCenter(currentTime: currentTime ?? 0.0, isPaused: false)
		}
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
		selectedMessage.seriesArt = seriesImage.pngData()

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
}
