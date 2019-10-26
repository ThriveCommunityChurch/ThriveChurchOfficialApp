//
//  NowPlayingViewControllerExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/29/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension NowPlayingViewController {
	
	@objc func playAudio() {
		
		if (self.reachedEnd) {
			// reset to the beginning
			self.progressIndicator.setProgress(0.0, animated: false)
			let time2: CMTime = CMTimeMake(value: Int64(0 * 1000 as Float64), timescale: 1000)
			player?.seek(to: time2)
			self.reachedEnd = false
		}
		
		SermonAVPlayer.sharedInstance.play()
		self.playButton.isEnabled = false
		self.stopButton.isEnabled = true
		self.pauseButton.isEnabled = true
		self.rwButton.isEnabled = true
		self.ffButton.isEnabled = true
		
		self.startTimer()
	}
	
	@objc func pauseAudio() {
		SermonAVPlayer.sharedInstance.pause()
		self.playButton.isEnabled = true
		self.stopButton.isEnabled = true
		self.pauseButton.isEnabled = false
		self.rwButton.isEnabled = true
		self.ffButton.isEnabled = true
		
		self.removeTimer()
	}
	
	@objc func stopAudio() {
		SermonAVPlayer.sharedInstance.stop()
		self.removeTimer()
		
		navigationController?.popViewController(animated: true)
	}
	
	@objc func fastForward() {
		guard let duration  = player?.currentItem?.duration else {
			return
		}
		let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
		let newTime = playerCurrentTime + seekDuration
		
		if newTime < CMTimeGetSeconds(duration) {
			
			self.removeTimer()
			
			self.currentTime = newTime
			self.currentProgressLabel.text = self.currentTime?.formatDurationForUI(displayAsPositional: true)
			
			let timeRemaining = (self.totalAudioTime ?? 0.0) - newTime
			self.durationRemainderLabel.text = "-\(timeRemaining.formatDurationForUI(displayAsPositional: true) ?? "")"
			
			let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
			player?.seek(to: time2)
			
			DispatchQueue.main.async {
				let progress = Float(newTime / (self.totalAudioTime ?? 1.0))
				
				// stop any current animation
				self.progressIndicator.layer.sublayers?.forEach { $0.removeAllAnimations() }
				
				// set progressView to 0%, with animated set to false
				// however if progress is NaN, set it to 0, if not then just set it to itself
				self.progressIndicator.setProgress(progress.isNaN ? 0.0 : progress, animated: false)
				
				self.startTimer()
			}
		}
	}
	
	@objc func rewind() {
		
		let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
		var newTime = playerCurrentTime - seekDuration
		
		if newTime < 0 {
			newTime = 0
			self.currentTime = 0
		}
		
		self.removeTimer()
		
		self.currentTime = newTime
		self.currentProgressLabel.text = self.currentTime?.formatDurationForUI(displayAsPositional: true)
		
		let timeRemaining = (self.totalAudioTime ?? 0.0) - newTime
		self.durationRemainderLabel.text = "-\(timeRemaining.formatDurationForUI(displayAsPositional: true) ?? "")"
		
		let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
		player?.seek(to: time2)
		
		DispatchQueue.main.async {
			let progress = Float(newTime / (self.totalAudioTime ?? 1.0))
			
			// stop any current animation
			self.progressIndicator.layer.sublayers?.forEach { $0.removeAllAnimations() }
			
			// set progressView to 0%, with animated set to false
			// however if progress is NaN, set it to 0, if not then just set it to itself
			self.progressIndicator.setProgress(progress.isNaN ? 0.0 : progress, animated: false)
			
			self.startTimer()
		}
	}
	
	@objc func downloadAudio() {
		
		self.downloadButton.isEnabled = false
		self.downloadButton.isHidden = true
		self.spinner.isHidden = false
		self.spinner.startAnimating()
		
		// prevent multiple presses of the button
		if !currentlyDownloading {
			self.currentlyDownloading = true
			
			saveFileToDisk()
		}
	}
	
	@objc func viewDownloads() {
		// First: Go to the downloaded messages collection and see if there are any there
		// if there are we can send these along to the next VC
		
		let vc = SermonDownloadsViewController()
		self.show(vc, sender: self)
	}
	
	func addMessageToDownloadList(message: SermonMessage) {
			
		self.downloadedMessageIds.append((messageForDownload?.MessageId)!)
		
		// we updated the list in memory, so write it down in defaults
		UserDefaults.standard.set(self.downloadedMessageIds, forKey: ApplicationVariables.DownloadedMessages)
		UserDefaults.standard.synchronize()
		
		// before we can place objects into Defaults they have to be encoded
		let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: message)
		
		// we have a reference to this message in the above Defaults array, so store everything
		UserDefaults.standard.set(encodedData, forKey: message.MessageId)
		UserDefaults.standard.synchronize()
	}
	
	func saveFileToDisk() {
		
		let filename = "\(messageForDownload?.MessageId ?? "").mp3"
		
		let documentsDirectory = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory,
														  in: FileManager.SearchPathDomainMask.userDomainMask).last!
		
		let outputURL = documentsDirectory.appendingPathComponent(filename)
		
		// so we need to make sure that the file that we downloaded does not already have a file
		// where we want to put it, there's not already something there
		let storageLocationAvailable = !FileManager.default.fileExists(atPath: "\(outputURL)")
		
		if !storageLocationAvailable {
			
			self.presentBasicAlertWTitle(title: "Error!",
										 message: "An error occurred while attempting " +
				"to download the file. Please ensure that this file is not already downloaded.")
			self.spinner.isHidden = true
			self.spinner.stopAnimating()
		}
		
		// download it again, since taking the AVPlayer Data and storing it is annoyingly hard
		let url = URL(string: (messageForDownload?.AudioUrl)!)!
		
		// set up your download task, progress on this seems a bit too far https://stackoverflow.com/a/30543917/6448167
		URLSession.shared.downloadTask(with: url) { (location, response, error) -> Void in
			
			if error != nil {
				print(error as Any)
			}
			
			if location == nil || response == nil {
				print("Response or location are nil, failing")
			}
			else {
				// what do we wanna do if this download fails or never finishes
				
				guard let httpURLResponse = response as? HTTPURLResponse,
					httpURLResponse.statusCode == 200,
					let mimeType = response?.mimeType, mimeType.hasPrefix("audio"),
					let location = location, error == nil
				else { return }
				do {
					// check that the user has enough disk space
					let space = Storage.getFreeSpace().toMB()
					
					let size = Double(httpURLResponse.expectedContentLength).toMB()
					self.messageForDownload?.downloadSizeMB = size
					
					if size > space {
						
						// UI Elements need to be presented with the main method
						// we should invoke this on the main thread asyncronously
						DispatchQueue.main.async {
							
							// the user has no space to save this audio
							let requiredSpace = (size - space).rounded(toPlace: 2)
							var reqSpaceString: String = ""
							
							// if we have a number that is greater or equal to 1 then we
							// should try to remove the trailing zeros. If its less
							// than that we want them
							if requiredSpace >= 1.0 {
								reqSpaceString = requiredSpace.removeZerosFromEnd()
							}
							else {
								reqSpaceString = "\(requiredSpace)"
							}
							
							self.currentlyDownloading = false
							self.presentBasicAlertWTitle(title: "Error!",
														  message: "Unable to download sermon message. " +
								"Please clear some space and try again. \(reqSpaceString) MB needed.")
							self.spinner.stopAnimating()
						}
					}
					else {
						
						// we already checked this above
						if storageLocationAvailable {
							
							try FileManager.default.moveItem(at: location, to: outputURL)
							
							self.messageForDownload?.LocalAudioURI = "\(outputURL)" // mp3
							self.finishDownload()
						}
					}
				} catch {
					// an error ocurred, let the user try again
					DispatchQueue.main.async {
						self.downloadButton.isEnabled = false
						self.currentlyDownloading = false
						
						self.downloadButton.isHidden = false
						self.spinner.isHidden = true
						self.spinner.stopAnimating()
						
						self.presentBasicAlertWTitle(title: "Error!",
													 message: "An error occurred while attempting " +
							"to download the file. Please ensure that this file is not already downloaded." +
						"\n\nIf you continue to encounter this issue, send us an email via wyatt@thrive-fl.org.")
						
						print(error)
					}
				}
			}
		}.resume()
	}
	
	func finishDownload() {
		
		// update the message object for the new URI for that saved audio on the device
		let currentUTCmilis = Date().timeIntervalSince1970 * 1000
		messageForDownload?.DownloadedOn = currentUTCmilis
		
		// once the audio has been stored, save the object in UserDefaults in the following order:
		// FIRST: get the downloadedMessageIds list from Defaults with the key in the AppVars
		readDLMessageIds()
		
		// NEXT: Update the list in memory and then use that list to update the one in Defaults
		addMessageToDownloadList(message: messageForDownload!)
		
		// on the series View controller table we can remove the download button option if a mesasge has been downloaded,
		// for this we will need to look at the storage in Defaults and see which messages have been saved
		
		// change button behavior now that things are happening
		DispatchQueue.main.async {
			self.downloadedSermonsButton?.isEnabled = true
			self.downloadButton.isEnabled = false
			self.currentlyDownloading = false
			
			self.downloadButton.isHidden = false
			self.spinner.isHidden = true
			self.spinner.stopAnimating()
		}
	}

	func readDLMessageIds() {
		if let loadedData = UserDefaults.standard.array(forKey: ApplicationVariables.DownloadedMessages) as? [String] {
			
			self.downloadedMessageIds = loadedData
		}
	}
	
	func checkIfUserHasDownloads(isInit: Bool = false) {
		
		// also disable the view downloads icon if they do not have any yet downloaded
		self.readDLMessageIds()
		
		if downloadedMessageIds.isEmpty {
			self.downloadedSermonsButton?.isEnabled = false
		}
		else {
			if !isInit {
				
				// since this is called at the beginning we don't need to worry about calling it again
				if self.downloadedMessageIds.contains(self.currentMessageId ?? "") {
					self.downloadButton.isEnabled = false
				}
			}
		}
		
		let filename = "\(messageForDownload?.MessageId ?? "").mp3"
		
		let documentsDirectory = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory,
														  in: FileManager.SearchPathDomainMask.userDomainMask).last!
		
		let outputURL = documentsDirectory.appendingPathComponent(filename)
		
		if FileManager.default.fileExists(atPath: "\(outputURL)") {
			self.downloadButton.isEnabled = false
		}
	}
	
	/// Calculates an easy animation for the progress bar to follow,
	/// can be called every few seconds or on a button press
	@objc func calculateAnimationsForProgressBar() {
		
		// stop any current animation
		self.progressIndicator.layer.sublayers?.forEach { $0.removeAllAnimations() }
		
		if self.player == nil || self.currentItem == nil{
			return
		}
		
		// set the animate method to have a beginning spot
		if (self.playerProgress?.isNaN)! {
			self.progressIndicator.setProgress(self.playerProgress ?? 0.0, animated: false)
		}
		
		// recalculate the current place in the bar
		let timeNow = self.currentItem?.currentTime().seconds
		let progress = Float((timeNow ?? 0.0) / (self.totalAudioTime ?? 1.0))
		
		// set progressView to 0%, with animated set to false
		// however if progress is NaN, set it to 0, if not then just set it to itself
		self.progressIndicator.setProgress(progress.isNaN ? 0.0 : progress, animated: false)
		
		// 1-second animation changing from where it is now to where it shoudld be
		UIView.animate(withDuration: 1, delay: 0, options: [], animations: { [unowned self] in
			self.progressIndicator.layoutIfNeeded()
		})
		
		if (progress >= 1.0) {
			// stop any current animation
			self.progressIndicator.layer.sublayers?.forEach { $0.removeAllAnimations() }
			self.reachedEnd = true
			
			// if we reached the end, then remove the timer and return from this method
			self.removeTimer()
			self.playButton.isEnabled = true
			self.pauseButton.isEnabled = false
			
			return
		}
	}
	
	func removeTimer() {
		self.currentProgressTimer?.invalidate()
		self.currentProgressTimer = nil
		self.currentProgressTimer = Timer()

		// stop any current animation
		self.progressIndicator.layer.sublayers?.forEach { $0.removeAllAnimations() }
	}
	
	func startTimer() {
		self.setupCurrentProgressTracker()
	}
	
	func setupCurrentProgressTracker() {
		self.currentProgressTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.processCurrentLocationChange), userInfo: nil, repeats: true)
	}
	
	@objc func processCurrentLocationChange() {
		
		// at the same time we should look to see if the player is playing
		let isPaused = SermonAVPlayer.sharedInstance.checkPausedStatus()
		let isPlaying = SermonAVPlayer.sharedInstance.checkPlayingStatus()
		
		if isPaused {
			self.playButton.isEnabled = true
			self.pauseButton.isEnabled = false
		}
		else if isPlaying {
			self.playButton.isEnabled = false
			self.pauseButton.isEnabled = true
		}
		
		self.currentTime = self.currentItem?.currentTime().seconds
		
		// first though we need to say that if the user reaches the end of the
		// playback that this timer is disposed
		
		if self.currentTime ?? 0.0 >= self.totalAudioTime ?? 0.0
		{
			// so if now is past the total time or if 2 seconds from now we will end,
			// remove and stop the timer
			
			self.currentProgressLabel.text = totalAudioTime?.formatDurationForUI(displayAsPositional: true)
			
			self.durationRemainderLabel.text = "-0:00"
			
			self.removeTimer()
			return
		}
		
		// set the current progres
		self.currentProgressLabel.text = currentTime?.formatDurationForUI(displayAsPositional: true)
		
		// set the duration text
		let durationRemaining = (self.totalAudioTime ?? 0.0) - (self.currentTime ?? 0.0)
		self.durationRemainderLabel.text = "-\(durationRemaining.formatDurationForUI(displayAsPositional: true) ?? "")"
		
		DispatchQueue.main.async {
			self.calculateAnimationsForProgressBar()
		}
	}
}
