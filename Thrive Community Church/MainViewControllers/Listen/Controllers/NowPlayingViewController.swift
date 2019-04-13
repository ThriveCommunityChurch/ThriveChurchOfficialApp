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

	// Data structures for processing events & loading data
	var player: AVPlayer?
	let seekDuration: Float64 = 15 // numSeconds
	var isDownloaded: Bool = false
	var messageForDownload: SermonMessage?
	var downloadedMessageIds = [String]()
	var currentMessageId: String? = nil
	var currentlyDownloading: Bool = false
	var sermonSeriesArt: UIImage?
	var loaded: Bool = false
	var reachedEnd: Bool = false
	
	var currentItem: AVPlayerItem? = nil

	var totalAudioTime: Double? = nil
	var currentTime: Double? = nil
	var playerProgress: Float? = nil
	var progressTimer: Timer? = nil
	var currentProgressTimer: Timer? = nil
	var lazyLoadDuration: Bool = false
	
	// UI Elements
	
	@IBOutlet weak var notPlayingText: UILabel!
	
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
	
	let progressIndicator: UIProgressView = {
		let indicator = UIProgressView()
		indicator.progressTintColor = UIColor.mainBlue
		indicator.trackTintColor = UIColor.darkGrey
		indicator.translatesAutoresizingMaskIntoConstraints = false
		return indicator
	}()
	
	let progressContainerView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let progressTrackerContainer: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
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
	
	let durationLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = UIFont(name: "Avenir-Book", size: 12)
		label.textColor = .lightGray
		label.numberOfLines = 1
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let currentProgressLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = UIFont(name: "Avenir-Book", size: 12)
		label.textColor = .lightGray
		label.numberOfLines = 1
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
	
	let spinner: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		indicator.activityIndicatorViewStyle = .whiteLarge
		indicator.color = .lightGray
		indicator.backgroundColor = .clear
		// Will need to scale down the spinner since it's a tad too big
		indicator.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
		indicator.translatesAutoresizingMaskIntoConstraints = false
		return indicator
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
	
	var downloadedSermonsButton: UIBarButtonItem?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// TODO: A progress bar below where the controls are would be a suuper nice
		// added touch to this already cool feature
		
		let image = UIImage(named: "downloads")
		downloadedSermonsButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(viewDownloads))
		downloadedSermonsButton?.tintColor = UIColor.white
		
		self.navigationItem.rightBarButtonItem = downloadedSermonsButton

        let playerStatus = self.checkPlayerStatus()

		if playerStatus {
			
			self.notPlayingText.isHidden = true
			setupViews()
			player = SermonAVPlayer.sharedInstance.getPlayer()
			
			loaded = true
		}
		else {
			self.checkIfUserHasDownloads(isInit: true)
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
		// TODO: If a user has a message downloaded and is playing it,
		// then they delete the download, the icon for download is still disabled
		// when they return to this view

		if !loaded {
			let playerStatus = self.checkPlayerStatus()
			
			if playerStatus {
				reinitForPlayingSound()
			}
			else {
				self.checkIfUserHasDownloads(isInit: true)
			}
		}
		
		let playerStatus = self.checkPlayerStatus()
		
		if loaded && playerStatus {
			
			reinitForPlayingSound()
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
		
		// prevent mem leaks
		self.removeTimer(removeProgressTimer: false, removeBoth: true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: - Methods
	func checkPlayerStatus() -> Bool {
		let playingStatus = SermonAVPlayer.sharedInstance.checkPlayingStatus()
		let pausedStatus = SermonAVPlayer.sharedInstance.checkPausedStatus()
		
		// if either of these are true, then the player is active
		let status = playingStatus || pausedStatus
		return status
	}
	
	private func reinitForPlayingSound() {
		
		self.notPlayingText.isHidden = true
		setupViews()
		player = SermonAVPlayer.sharedInstance.getPlayer()
		
		// make sure that the buttons are init properly
		loaded = true
		self.playButton.isEnabled = false
		self.playButton.isEnabled = !SermonAVPlayer.sharedInstance.checkPlayingStatus()
		self.pauseButton.isEnabled = !SermonAVPlayer.sharedInstance.checkPausedStatus()
		self.rwButton.isEnabled = true
		self.ffButton.isEnabled = true
	}
	
	func setupViews() {
		
		// add all the UI Elements first
		view.addSubview(seriesArt)
		view.addSubview(progressContainerView)
		view.addSubview(progressTrackerContainer)
		view.addSubview(playerControlsView)
		view.addSubview(detailsBackgroundView)
		
		// add the things to the containers
		progressTrackerContainer.addSubview(durationLabel)
		progressTrackerContainer.addSubview(currentProgressLabel)
		playerControlsView.addSubview(controlsStackView)
		detailsBackgroundView.addSubview(messageTitleLabel)
		detailsBackgroundView.addSubview(speakerLabel)
		detailsBackgroundView.addSubview(dateLabel)
		detailsBackgroundView.addSubview(passageLabel)
		progressContainerView.addSubview(progressIndicator)
		
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
				progressContainerView.topAnchor.constraint(equalTo: seriesArt.bottomAnchor, constant: 16),
				progressContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				progressContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				progressContainerView.heightAnchor.constraint(equalToConstant: 16),
				progressIndicator.leadingAnchor.constraint(equalTo: progressContainerView.leadingAnchor, constant: 8),
				progressIndicator.trailingAnchor.constraint(equalTo: progressContainerView.trailingAnchor, constant: -8),
				progressIndicator.centerYAnchor.constraint(equalTo: progressContainerView.centerYAnchor),
				progressIndicator.heightAnchor.constraint(equalToConstant: 3),
				progressTrackerContainer.topAnchor.constraint(lessThanOrEqualTo: progressContainerView.bottomAnchor, constant: 0),
				progressTrackerContainer.heightAnchor.constraint(equalToConstant: 16),
				progressTrackerContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
				progressTrackerContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
				currentProgressLabel.leadingAnchor.constraint(equalTo: progressTrackerContainer.leadingAnchor),
				currentProgressLabel.centerYAnchor.constraint(equalTo: progressTrackerContainer.centerYAnchor),
				currentProgressLabel.widthAnchor.constraint(equalToConstant: 35),
				durationLabel.trailingAnchor.constraint(equalTo: progressTrackerContainer.trailingAnchor),
				durationLabel.centerYAnchor.constraint(equalTo: progressTrackerContainer.centerYAnchor),
				durationLabel.widthAnchor.constraint(equalToConstant: 45),
				playerControlsView.topAnchor.constraint(equalTo: progressTrackerContainer.bottomAnchor, constant: 16),
				playerControlsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
				playerControlsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
				playerControlsView.heightAnchor.constraint(equalToConstant: 35),
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
				progressContainerView.topAnchor.constraint(equalTo: seriesArt.bottomAnchor, constant: 16),
				progressContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				progressContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				progressContainerView.heightAnchor.constraint(equalToConstant: 16),
				progressIndicator.leadingAnchor.constraint(equalTo: progressContainerView.leadingAnchor, constant: 8),
				progressIndicator.trailingAnchor.constraint(equalTo: progressContainerView.trailingAnchor, constant: -8),
				progressIndicator.centerYAnchor.constraint(equalTo: progressContainerView.centerYAnchor),
				progressIndicator.heightAnchor.constraint(equalToConstant: 3),
				playerControlsView.topAnchor.constraint(equalTo: seriesArt.bottomAnchor, constant: 24),
				playerControlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
				playerControlsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
				playerControlsView.heightAnchor.constraint(equalToConstant: 25),
				detailsBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				detailsBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
				durationLabel.leadingAnchor.constraint(equalTo: passageLabel.leadingAnchor),
				durationLabel.trailingAnchor.constraint(equalTo: passageLabel.trailingAnchor),
				durationLabel.centerYAnchor.constraint(equalTo: speakerLabel.centerYAnchor),
				controlsStackView.leadingAnchor.constraint(equalTo: playerControlsView.leadingAnchor),
				controlsStackView.trailingAnchor.constraint(equalTo: playerControlsView.trailingAnchor),
				controlsStackView.topAnchor.constraint(equalTo: playerControlsView.topAnchor),
				controlsStackView.bottomAnchor.constraint(equalTo: playerControlsView.bottomAnchor)
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
		downloadStackView.addArrangedSubview(spinner)
		rwStackView.addArrangedSubview(rwButton)
		ffStackView.addArrangedSubview(ffButton)
		
		spacingView2.widthAnchor.constraint(equalTo: spacingView.widthAnchor).isActive = true
		spacingView3.widthAnchor.constraint(equalTo: spacingView.widthAnchor).isActive = true
		spacingView4.widthAnchor.constraint(equalTo: spacingView.widthAnchor).isActive = true
		spacingView5.widthAnchor.constraint(equalTo: spacingView.widthAnchor).isActive = true
		spacingView6.widthAnchor.constraint(equalTo: spacingView.widthAnchor).isActive = true
		spacingView7.widthAnchor.constraint(equalTo: spacingView.widthAnchor).isActive = true
		
		// since we are playing we need to disable the play button
		self.playButton.isEnabled = !SermonAVPlayer.sharedInstance.checkPlayingStatus()
		self.pauseButton.isEnabled = !SermonAVPlayer.sharedInstance.checkPausedStatus()
		
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
								"messageDate": messageDate,
								"isDownloaded": isDownloaded,
								"message": message]
		*/
		
		let dataDump = SermonAVPlayer.sharedInstance.getDataForPlayback()!

		self.seriesArt.image = dataDump["sermonGraphic"] as? UIImage
		self.messageTitleLabel.text = "\(dataDump["messageTitle"] as? String ?? "")"
		self.speakerLabel.text = "\(dataDump["speaker"] as? String ?? "")"
		self.dateLabel.text = "\(dataDump["messageDate"] as? String ?? "")"
		self.passageLabel.text = "\(dataDump["passageRef"] as? String ?? "")"
		
		let sermonMessage = (dataDump["message"] as? SermonMessage)
		self.currentMessageId = sermonMessage?.MessageId
		self.totalAudioTime = sermonMessage?.AudioDuration
		
		// inside here we will disable the download button
		self.checkIfUserHasDownloads()
		
		// we don't want to allocate memory for this message object if we don't have to
		if self.downloadButton.isEnabled {
			self.messageForDownload = dataDump["message"] as? SermonMessage
			self.messageForDownload?.seriesArt = UIImagePNGRepresentation((dataDump["sermonGraphic"] as? UIImage)!)
			self.messageForDownload?.seriesTitle = "\(dataDump["messageTitle"] as? String ?? "")"
		}
		
		// at the very end here we should render the progress bar of the player
		// because these values may change ever so slightly as this method may take a few ms to execute
		
		//get the duration and playing time
		currentItem = player?.currentItem
		currentTime = currentItem?.currentTime().seconds
		let progress = (currentTime ?? 0.0) / (totalAudioTime ?? 1.0)
		playerProgress = Float(progress)
		
		// set the current progres
		self.currentProgressLabel.text = currentTime?.formatDurationForUI(displayAsPositional: true)
		
		// once we set the progress we need to setup a timer so that we can track the progress every second
		self.setupCurrentProgressTracker()
		
		// set the duration text
		self.durationLabel.text = totalAudioTime?.formatDurationForUI(displayAsPositional: true)
		
		// stop any current animation
		self.progressIndicator.layer.sublayers?.forEach { $0.removeAllAnimations() }
		
		// set progressView to 0%, with animated set to false
		self.progressIndicator.setProgress(playerProgress ?? 0.0, animated: true)
		
		progressTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.calculateAnimationsForProgressBar), userInfo: nil, repeats: true)
		
	}
}
