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
		SermonAVPlayer.sharedInstance.play()
		self.playButton.isEnabled = false
		self.stopButton.isEnabled = true
		self.pauseButton.isEnabled = true
		self.rwButton.isEnabled = true
		self.ffButton.isEnabled = true
	}
	
	@objc func pauseAudio() {
		SermonAVPlayer.sharedInstance.pause()
		self.playButton.isEnabled = true
		self.stopButton.isEnabled = true
		self.pauseButton.isEnabled = false
		self.rwButton.isEnabled = true
		self.ffButton.isEnabled = true
	}
	
	@objc func stopAudio() {
		SermonAVPlayer.sharedInstance.stop()
		
		navigationController?.popViewController(animated: true)
	}
	
	@objc func fastForward() {
		guard let duration  = player?.currentItem?.duration else {
			return
		}
		let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
		let newTime = playerCurrentTime + seekDuration
		
		if newTime < CMTimeGetSeconds(duration) {
			
			let time2: CMTime = CMTimeMake(Int64(newTime * 1000 as Float64), 1000)
			player?.seek(to: time2)
		}
	}
	
	@objc func rewind() {
		
		let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
		var newTime = playerCurrentTime - seekDuration
		
		if newTime < 0 {
			newTime = 0
		}
		let time2: CMTime = CMTimeMake(Int64(newTime * 1000 as Float64), 1000)
		player?.seek(to: time2)
		
	}
	
	@objc func downloadAudio() {
		
		// save the audio that's currently playing to some place loaclly
		guard let url = URL.init(string: messageForDownload?.AudioUrl ?? "") else { return }
		let playerItem = AVPlayerItem.init(url: url)
		let _ = AVPlayer.init(playerItem: playerItem)
		// instead of above see this https://stackoverflow.com/a/37611489/6448167
		
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
		self.downloadedSermonsButton?.isEnabled = true
		self.downloadButton.isEnabled = false
	}
	
	@objc func viewDownloads() {
		// First: Go to the downloaded messages collection and see if there are any there
		// if there are we can send these along to the next VC
		print("\nGoing to downloads....")
		
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
		
		// READ FROM THE messageId collection like so
		//let decoded = UserDefaults.standard.object(forKey: message.MessageId) as! Data
		//let decodedSermonMessage = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! SermonMessage
	}
	
	// do this on the DownloadPlayerVC
//	func readDownloadedMessages() {
//		let MessageIds = readDLMessageIds()
//
//		for messageId in MessageIds {
//
//		}
//	}

	func readDLMessageIds() {
		if let loadedData = UserDefaults.standard.array(forKey: ApplicationVariables.DownloadedMessages) as? [String] {
			self.downloadedMessageIds = loadedData
			
		}
	}
	
	func checkIfUserHasDownloads(isInit: Bool = false) {
		
		// also disable the view downloads icon if they do not have any yet downloaded
		self.readDLMessageIds()
		
		if downloadedMessageIds.count == 0 {
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
	}
}
