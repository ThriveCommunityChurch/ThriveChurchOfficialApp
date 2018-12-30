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
	
	/*
		Order in the horiz controlsStackView is as follows:
	
		spacingView
		rwStackView
		spacingView2
		pauseStackView
		playStackView
		spacingView3
		ffStackView
		spacingView4
		stopStackView
	*/
	
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
		
		self.playButton.isEnabled = false
		self.stopButton.isEnabled = false
		self.pauseButton.isEnabled = false
		self.rwButton.isEnabled = false
		self.ffButton.isEnabled = false
		self.downloadButton.isEnabled = false
		
		dismiss(animated: true, completion: nil)
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
		
		print("Coming soon to a downlod folder near you...")
	}
}
