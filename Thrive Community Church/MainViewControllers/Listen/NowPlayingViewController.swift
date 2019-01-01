//
//  NowPlayingViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/29/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class NowPlayingViewController: UIViewController {

	// UI Elements
	@IBOutlet weak var notPlayingText: UILabel!
	var player: AVPlayer?
	let seekDuration: Float64 = 15 // numSeconds
	
	let seriesArt: UIImageView = {
		let image = UIImageView()
		image.backgroundColor = .red
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}()
	
	let messageTitleLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = UIFont(name: "Avenir-Medium", size: 16)
		label.textColor = .lightGray
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let detailsBackgroundView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.almostBlack
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let playerControlsView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let spacingView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let spacingView2: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let spacingView3: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let spacingView4: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let spacingView5: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let spacingView6: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let spacingView7: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let controlsStackView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.distribution = .fillEqually
		stack.spacing = 8
		stack.alignment = .fill
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	// Stack views for each item in list
	let downloadStackView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fillEqually
		stack.spacing = 0
		stack.alignment = .fill
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	let playStackView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fill
		stack.spacing = 0
		stack.alignment = .fill
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	let pauseStackView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fill
		stack.spacing = 0
		stack.alignment = .fill
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	let stopStackView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fill
		stack.spacing = 0
		stack.alignment = .fill
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	let rwStackView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fill
		stack.spacing = 0
		stack.alignment = .fill
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	let ffStackView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fill
		stack.spacing = 0
		stack.alignment = .fill
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	let speakerLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Book", size: 15)
		label.textColor = .lightGray
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let dateLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Book", size: 15)
		label.textColor = .lightGray
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let passageLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .right
		label.font = UIFont(name: "Avenir-Book", size: 15)
		label.textColor = .lightGray
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let downloadButton: UIButton = {
		let button = UIButton()
		let image = UIImage(named: "download")
		button.imageView?.contentMode = .scaleAspectFit
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(downloadAudio), for: .touchUpInside)
		return button
	}()
	
	let pauseButton: UIButton = {
		let button = UIButton()
		let image = UIImage(named: "pause")
		button.imageView?.contentMode = .scaleAspectFit
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(pauseAudio), for: .touchUpInside)
		return button
	}()
	
	let ffButton: UIButton = {
		let button = UIButton()
		let image = UIImage(named: "fastForward")
		button.imageView?.contentMode = .scaleAspectFit
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(fastForward), for: .touchUpInside)
		return button
	}()
	
	let rwButton: UIButton = {
		let button = UIButton()
		let image = UIImage(named: "rewind")
		button.imageView?.contentMode = .scaleAspectFit
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(rewind), for: .touchUpInside)
		return button
	}()
	
	let playButton: UIButton = {
		let button = UIButton()
		let image = UIImage(named: "play")
		button.imageView?.contentMode = .scaleAspectFit
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
		return button
	}()
	
	let stopButton: UIButton = {
		let button = UIButton()
		let image = UIImage(named: "stop")
		button.imageView?.contentMode = .scaleAspectFit
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(stopAudio), for: .touchUpInside)
		return button
	}()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// TODO: Add a downloads view that allows a user to listen to anything that's
		// been stored on their device. Use a Right nav bar button and a TableViewController
		
		// TODO: Also, a progress bar below where the controls are would be a suuper nice
		// added touch to this already cool feature

        let playerStatus = self.checkPlayerStatus()

		if playerStatus {
			
			self.notPlayingText.isHidden = true
			setupViews()
			player = SermonAVPlayer.sharedInstance.getPlayer()
		}
    }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: - Methods
	func checkPlayerStatus() -> Bool {
		let status = SermonAVPlayer.sharedInstance.checkPlayingStatus()
		return status
	}
	
	func setupViews() {
		
		// add all the UI Elements first
		view.addSubview(seriesArt)
		view.addSubview(playerControlsView)
		view.addSubview(detailsBackgroundView)
		playerControlsView.addSubview(controlsStackView)
		detailsBackgroundView.addSubview(messageTitleLabel)
		detailsBackgroundView.addSubview(speakerLabel)
		detailsBackgroundView.addSubview(dateLabel)
		detailsBackgroundView.addSubview(passageLabel)
		
		// calculate the size for the image view
		let width = view.frame.width
		let height = (width) * (9 / 16) // 16x9 ratio
		
		// now add the constraints
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				seriesArt.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				seriesArt.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				seriesArt.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				seriesArt.heightAnchor.constraint(equalToConstant: height),
				playerControlsView.topAnchor.constraint(equalTo: seriesArt.bottomAnchor, constant: 24),
				playerControlsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
				playerControlsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
				playerControlsView.heightAnchor.constraint(equalToConstant: 25),
				detailsBackgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				detailsBackgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				detailsBackgroundView.topAnchor.constraint(equalTo: playerControlsView.bottomAnchor, constant: 24),
				detailsBackgroundView.heightAnchor.constraint(equalToConstant: 120),
				messageTitleLabel.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: 16),
				messageTitleLabel.topAnchor.constraint(equalTo: detailsBackgroundView.topAnchor, constant: 16),
				speakerLabel.leadingAnchor.constraint(equalTo: messageTitleLabel.leadingAnchor),
				speakerLabel.topAnchor.constraint(equalTo: messageTitleLabel.bottomAnchor, constant: 16),
				dateLabel.leadingAnchor.constraint(equalTo: speakerLabel.leadingAnchor),
				dateLabel.topAnchor.constraint(equalTo: speakerLabel.bottomAnchor, constant: 16),
				passageLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
				passageLabel.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -16),
				controlsStackView.leadingAnchor.constraint(equalTo: playerControlsView.leadingAnchor),
				controlsStackView.trailingAnchor.constraint(equalTo: playerControlsView.trailingAnchor),
				controlsStackView.topAnchor.constraint(equalTo: playerControlsView.topAnchor),
				controlsStackView.bottomAnchor.constraint(equalTo: playerControlsView.bottomAnchor)
			])
		} else {
			// Fallback on earlier versions
			NSLayoutConstraint.activate([
				seriesArt.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				seriesArt.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				seriesArt.topAnchor.constraint(equalTo: view.topAnchor),
				seriesArt.heightAnchor.constraint(equalToConstant: height),
				messageTitleLabel.topAnchor.constraint(equalTo: seriesArt.bottomAnchor, constant: 16),
				messageTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
				messageTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
				detailsBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				detailsBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				detailsBackgroundView.topAnchor.constraint(equalTo: messageTitleLabel.bottomAnchor, constant: 16),
				detailsBackgroundView.heightAnchor.constraint(equalToConstant: 120),
				speakerLabel.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: 16),
				speakerLabel.topAnchor.constraint(equalTo: detailsBackgroundView.topAnchor, constant: 16)
			])
		}
		
		// add elements to the stack view
		controlsStackView.addArrangedSubview(spacingView)
		controlsStackView.addArrangedSubview(rwStackView)
		controlsStackView.addArrangedSubview(spacingView2)
		controlsStackView.addArrangedSubview(pauseStackView)
		controlsStackView.addArrangedSubview(spacingView3)
		controlsStackView.addArrangedSubview(playStackView)
		controlsStackView.addArrangedSubview(spacingView4)
		controlsStackView.addArrangedSubview(ffStackView)
		controlsStackView.addArrangedSubview(spacingView5)
		controlsStackView.addArrangedSubview(stopStackView)
		controlsStackView.addArrangedSubview(spacingView6)
		controlsStackView.addArrangedSubview(downloadStackView)
		controlsStackView.addArrangedSubview(spacingView7)
		
		playStackView.addArrangedSubview(playButton)
		pauseStackView.addArrangedSubview(pauseButton)
		stopStackView.addArrangedSubview(stopButton)
		downloadStackView.addArrangedSubview(downloadButton)
		rwStackView.addArrangedSubview(rwButton)
		ffStackView.addArrangedSubview(ffButton)
		
		spacingView2.widthAnchor.constraint(equalTo: spacingView.widthAnchor).isActive = true
		spacingView3.widthAnchor.constraint(equalTo: spacingView.widthAnchor).isActive = true
		spacingView4.widthAnchor.constraint(equalTo: spacingView.widthAnchor).isActive = true
		spacingView5.widthAnchor.constraint(equalTo: spacingView.widthAnchor).isActive = true
		spacingView6.widthAnchor.constraint(equalTo: spacingView.widthAnchor).isActive = true
		spacingView7.widthAnchor.constraint(equalTo: spacingView.widthAnchor).isActive = true
		
		// since we are playing we need to disable the play button
		self.playButton.isEnabled = false
		
		self.addDataToViews()
	}
	
	func addDataToViews() {
		
		/*
		the response of this method call is [String: Any] currently appearing like so:
		
			let responseDict = ["seriesTitle": seriesTitle,
								"weekNum": weekNum,
								"speaker": speaker,
								"passageRef": passageRef,
								"messageTitle": messageTitle,
								"sermonGraphic": sermonGraphic as Any,
								"messageDate": messageDate]
		*/
		
		let dataDump = SermonAVPlayer.sharedInstance.getDataForPlayback()!

		self.seriesArt.image = dataDump["sermonGraphic"] as? UIImage
		self.messageTitleLabel.text = "\(dataDump["messageTitle"] as? String ?? "")"
		self.speakerLabel.text = "\(dataDump["speaker"] as? String ?? "")"
		self.dateLabel.text = "Date: \(dataDump["messageDate"] as? String ?? "")"
		self.passageLabel.text = "\(dataDump["passageRef"] as? String ?? "")"
	}
}
