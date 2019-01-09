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
		
		let filename = "\(messageForDownload?.MessageId ?? "").aifc"
		
		let documentsDirectory = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory,
														  in: FileManager.SearchPathDomainMask.userDomainMask).last!
		
		let outputURL = documentsDirectory.appendingPathComponent(filename)
		
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
							self.currentlyDownloading = false
							let alert = UIAlertController(title: "Error!",
														  message: "Unable to download sermon message. " +
								"Please clear some space and try again. \(size - space) needed.",
								preferredStyle: .alert)
							
							let OkAction = UIAlertAction(title: "OK", style: .default, handler: nil)
							
							alert.addAction(OkAction)
							self.present(alert, animated: true, completion: nil)
						}
					}
					else {
						try FileManager.default.moveItem(at: location, to: outputURL)
	
						self.messageForDownload?.LocalAudioURI = "\(outputURL)" // aifc
						self.finishDownload()
					}
				} catch {
					// an error ocurred
					self.currentlyDownloading = false
					print(error)
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
