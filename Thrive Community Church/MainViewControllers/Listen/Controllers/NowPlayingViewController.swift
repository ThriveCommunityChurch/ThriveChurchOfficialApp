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
	var currentProgressTimer: Timer? = nil
	var lazyLoadDuration: Bool = false

	// UI Elements with modern design

	let notPlayingText: UILabel = {
		let label = UILabel()
		label.text = "No audio is currently playing"
		label.textAlignment = .center
		label.font = UIFont(name: "Avenir-Medium", size: 20)
		label.textColor = .lightGray
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false

		// Add subtle text shadow for better readability
		label.layer.shadowColor = UIColor.black.cgColor
		label.layer.shadowOffset = CGSize(width: 0, height: 1)
		label.layer.shadowRadius = 2
		label.layer.shadowOpacity = 0.3

		return label
	}()

	let seriesArtContainer: UIView = {
		let container = UIView()
		container.backgroundColor = .clear
		container.layer.cornerRadius = 12
		container.layer.shadowColor = UIColor.black.cgColor
		container.layer.shadowOffset = CGSize(width: 0, height: 4)
		container.layer.shadowRadius = 8
		container.layer.shadowOpacity = 0.4
		container.layer.masksToBounds = false
		container.translatesAutoresizingMaskIntoConstraints = false
		return container
	}()

	let seriesArt: UIImageView = {
		let image = UIImageView()
		image.backgroundColor = .darkGrey
		image.contentMode = .scaleAspectFill
		image.layer.cornerRadius = 12
		image.layer.masksToBounds = true
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}()

	let messageTitleLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Heavy", size: 28)
		label.textColor = .white
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.translatesAutoresizingMaskIntoConstraints = false

		// Add subtle text shadow for better readability
		label.layer.shadowColor = UIColor.black.cgColor
		label.layer.shadowOffset = CGSize(width: 0, height: 1)
		label.layer.shadowRadius = 2
		label.layer.shadowOpacity = 0.3

		return label
	}()

	let progressIndicator: UIProgressView = {
		let indicator = UIProgressView()
		indicator.progressTintColor = UIColor.mainBlue
		indicator.trackTintColor = UIColor.darkGrey.withAlphaComponent(0.3)
		indicator.layer.cornerRadius = 2
		indicator.clipsToBounds = true
		indicator.translatesAutoresizingMaskIntoConstraints = false
		return indicator
	}()

	let progressContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
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
		view.layer.cornerRadius = 12
		view.translatesAutoresizingMaskIntoConstraints = false

		// Add modern card shadow
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOffset = CGSize(width: 0, height: 4)
		view.layer.shadowRadius = 8
		view.layer.shadowOpacity = 0.4
		view.layer.masksToBounds = false

		return view
	}()

	let playerControlsView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
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
		label.font = UIFont(name: "Avenir-Medium", size: 18)
		label.textColor = .mainBlue
		label.numberOfLines = 2
		label.lineBreakMode = .byWordWrapping
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let durationRemainderLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = UIFont(name: "Avenir-Medium", size: 14)
		label.textColor = .lightGray
		label.numberOfLines = 1
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let currentProgressLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = UIFont(name: "Avenir-Medium", size: 14)
		label.textColor = .lightGray
		label.numberOfLines = 1
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let dateLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Book", size: 16)
		label.textColor = .lightGray
		label.numberOfLines = 2
		label.lineBreakMode = .byWordWrapping
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let passageLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .right
		label.font = UIFont(name: "Avenir-Medium", size: 16)
		label.textColor = .mainBlue.withAlphaComponent(0.8)
		label.numberOfLines = 2
		label.lineBreakMode = .byWordWrapping
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let downloadButton: UIButton = {
		let button = UIButton()
		let image = UIImage(named: "download")
		button.imageView?.contentMode = .scaleAspectFit
		button.setImage(image, for: .normal)
		button.tintColor = .mainBlue
		button.backgroundColor = .clear
		return button
	}()

	let spinner: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		indicator.style = .large
		indicator.color = .mainBlue
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
		button.tintColor = .white
		button.backgroundColor = .clear
		return button
	}()

	let ffButton: UIButton = {
		let button = UIButton()
		let image = UIImage(named: "fastForward")
		button.imageView?.contentMode = .scaleAspectFit
		button.setImage(image, for: .normal)
		button.tintColor = .white
		button.backgroundColor = .clear
		return button
	}()

	let rwButton: UIButton = {
		let button = UIButton()
		let image = UIImage(named: "rewind")
		button.imageView?.contentMode = .scaleAspectFit
		button.setImage(image, for: .normal)
		button.tintColor = .white
		button.backgroundColor = .clear
		return button
	}()

	let playButton: UIButton = {
		let button = UIButton()
		let image = UIImage(named: "play")
		button.imageView?.contentMode = .scaleAspectFit
		button.setImage(image, for: .normal)
		button.tintColor = .mainBlue
		button.backgroundColor = .clear
		return button
	}()

	let stopButton: UIButton = {
		let button = UIButton()
		let image = UIImage(named: "stop")
		button.imageView?.contentMode = .scaleAspectFit
		button.setImage(image, for: .normal)
		button.tintColor = .red
		button.backgroundColor = .clear
		return button
	}()

	var downloadedSermonsButton: UIBarButtonItem?

	override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialViews()
        setupNavigationBar()

		// added touch to this already cool feature

        let playerStatus = self.checkPlayerStatus()

		if playerStatus {

			self.notPlayingText.isHidden = true
			player = SermonAVPlayer.sharedInstance.getPlayer()

			loaded = true
		}
		else {
			self.checkIfUserHasDownloads(isInit: true)
		}
    }

    // MARK: - Setup Views
    func setupInitialViews() {
        view.backgroundColor = UIColor.almostBlack
        view.addSubview(notPlayingText)

        NSLayoutConstraint.activate([
            notPlayingText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notPlayingText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            notPlayingText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notPlayingText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    func setupNavigationBar() {
        title = "Now Playing"

        let image = UIImage(named: "downloads")
        downloadedSermonsButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(viewDownloads))
        downloadedSermonsButton?.tintColor = UIColor.white

        navigationItem.rightBarButtonItem = downloadedSermonsButton
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
		else {

			let playerStatus = self.checkPlayerStatus()

			if loaded && playerStatus {

				reinitForPlayingSound()
			}
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)

		// prevent mem leaks
		self.removeTimer()
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
		self.player = SermonAVPlayer.sharedInstance.getPlayer()

		setupViews()

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
		view.addSubview(seriesArtContainer)
		seriesArtContainer.addSubview(seriesArt)
		view.addSubview(progressContainerView)
		view.addSubview(progressTrackerContainer)
		view.addSubview(playerControlsView)
		view.addSubview(detailsBackgroundView)

		// add the things to the containers
		progressTrackerContainer.addSubview(durationRemainderLabel)
		progressTrackerContainer.addSubview(currentProgressLabel)
		playerControlsView.addSubview(controlsStackView)
		detailsBackgroundView.addSubview(messageTitleLabel)
		detailsBackgroundView.addSubview(speakerLabel)
		detailsBackgroundView.addSubview(dateLabel)
		detailsBackgroundView.addSubview(passageLabel)
		progressContainerView.addSubview(progressIndicator)

		// calculate the size for the image view with modern aspect ratio
		let availableWidth = view.frame.width - 32 // Account for 16pt margins on each side
		let maxWidth: CGFloat = 500 // Maximum width for better proportions on iPad
		let width = min(availableWidth, maxWidth)
		let height = (width) * (9 / 16) // 16x9 ratio

		// now add the constraints with modern spacing and margins
		NSLayoutConstraint.activate([
			// Series Art Container with 16pt horizontal margins and modern card design
			seriesArtContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			seriesArtContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			seriesArtContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
			seriesArtContainer.heightAnchor.constraint(equalToConstant: height),

			// Series Art fills the container
			seriesArt.leadingAnchor.constraint(equalTo: seriesArtContainer.leadingAnchor),
			seriesArt.trailingAnchor.constraint(equalTo: seriesArtContainer.trailingAnchor),
			seriesArt.topAnchor.constraint(equalTo: seriesArtContainer.topAnchor),
			seriesArt.bottomAnchor.constraint(equalTo: seriesArtContainer.bottomAnchor),

			// Progress Container with improved spacing
			progressContainerView.topAnchor.constraint(equalTo: seriesArtContainer.bottomAnchor, constant: 24),
			progressContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			progressContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			progressContainerView.heightAnchor.constraint(equalToConstant: 20),

			// Progress Indicator with enhanced styling
			progressIndicator.leadingAnchor.constraint(equalTo: progressContainerView.leadingAnchor),
			progressIndicator.trailingAnchor.constraint(equalTo: progressContainerView.trailingAnchor),
			progressIndicator.centerYAnchor.constraint(equalTo: progressContainerView.centerYAnchor),
			progressIndicator.heightAnchor.constraint(equalToConstant: 4),

			// Progress Tracker with consistent spacing
			progressTrackerContainer.topAnchor.constraint(equalTo: progressContainerView.bottomAnchor, constant: 8),
			progressTrackerContainer.heightAnchor.constraint(equalToConstant: 20),
			progressTrackerContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			progressTrackerContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

			// Progress Labels with improved positioning
			currentProgressLabel.leadingAnchor.constraint(equalTo: progressTrackerContainer.leadingAnchor),
			currentProgressLabel.centerYAnchor.constraint(equalTo: progressTrackerContainer.centerYAnchor),
			currentProgressLabel.widthAnchor.constraint(equalToConstant: 50),
			durationRemainderLabel.trailingAnchor.constraint(equalTo: progressTrackerContainer.trailingAnchor),
			durationRemainderLabel.centerYAnchor.constraint(equalTo: progressTrackerContainer.centerYAnchor),
			durationRemainderLabel.widthAnchor.constraint(equalToConstant: 60),

			// Player Controls with modern card design
			playerControlsView.topAnchor.constraint(equalTo: progressTrackerContainer.bottomAnchor, constant: 24),
			playerControlsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			playerControlsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			playerControlsView.heightAnchor.constraint(equalToConstant: 60),

			// Details Background with enhanced spacing
			detailsBackgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			detailsBackgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			detailsBackgroundView.topAnchor.constraint(equalTo: playerControlsView.bottomAnchor, constant: 24),
			detailsBackgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: 140),

			// Content within details card with improved hierarchy
			messageTitleLabel.leadingAnchor.constraint(equalTo: detailsBackgroundView.leadingAnchor, constant: 20),
			messageTitleLabel.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -20),
			messageTitleLabel.topAnchor.constraint(equalTo: detailsBackgroundView.topAnchor, constant: 20),

			speakerLabel.leadingAnchor.constraint(equalTo: messageTitleLabel.leadingAnchor),
			speakerLabel.trailingAnchor.constraint(equalTo: messageTitleLabel.trailingAnchor),
			speakerLabel.topAnchor.constraint(equalTo: messageTitleLabel.bottomAnchor, constant: 12),

			dateLabel.leadingAnchor.constraint(equalTo: speakerLabel.leadingAnchor),
			dateLabel.topAnchor.constraint(equalTo: speakerLabel.bottomAnchor, constant: 8),
			dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: detailsBackgroundView.bottomAnchor, constant: -20),

			passageLabel.trailingAnchor.constraint(equalTo: detailsBackgroundView.trailingAnchor, constant: -20),
			passageLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
			passageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: dateLabel.trailingAnchor, constant: 16),

			// Controls Stack View with proper padding
			controlsStackView.leadingAnchor.constraint(equalTo: playerControlsView.leadingAnchor, constant: 16),
			controlsStackView.trailingAnchor.constraint(equalTo: playerControlsView.trailingAnchor, constant: -16),
			controlsStackView.topAnchor.constraint(equalTo: playerControlsView.topAnchor, constant: 12),
			controlsStackView.bottomAnchor.constraint(equalTo: playerControlsView.bottomAnchor, constant: -12)
		])

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

		// Setup button targets with enhanced feedback
		playButton.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
		playButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
		playButton.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])

		pauseButton.addTarget(self, action: #selector(pauseAudio), for: .touchUpInside)
		pauseButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
		pauseButton.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])

		stopButton.addTarget(self, action: #selector(stopAudio), for: .touchUpInside)
		stopButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
		stopButton.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])

		downloadButton.addTarget(self, action: #selector(downloadAudio), for: .touchUpInside)
		downloadButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
		downloadButton.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])

		rwButton.addTarget(self, action: #selector(rewind), for: .touchUpInside)
		rwButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
		rwButton.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])

		ffButton.addTarget(self, action: #selector(fastForward), for: .touchUpInside)
		ffButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
		ffButton.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])

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
			self.messageForDownload?.seriesArt = (dataDump["sermonGraphic"] as? UIImage)!.pngData()
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
		let durationRemaining = (self.totalAudioTime ?? 0.0) - (self.currentTime ?? 0.0)
		self.durationRemainderLabel.text = "-\(durationRemaining.formatDurationForUI(displayAsPositional: true) ?? "")"

		// stop any current animation
		self.progressIndicator.layer.sublayers?.forEach { $0.removeAllAnimations() }

		// set progressView to 0%, with animated set to false
		self.progressIndicator.setProgress(playerProgress ?? 0.0, animated: false)
	}

	// MARK: - Enhanced Button Interactions

	@objc private func buttonTouchDown(_ sender: UIButton) {
		// Add haptic feedback based on button type
		let feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle

		if sender == playButton || sender == pauseButton {
			feedbackStyle = .medium
		} else if sender == stopButton {
			feedbackStyle = .heavy
		} else {
			feedbackStyle = .light
		}

		let impactFeedback = UIImpactFeedbackGenerator(style: feedbackStyle)
		impactFeedback.impactOccurred()

		// Enhanced visual feedback for elegant button design
		UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: [.curveEaseInOut, .allowUserInteraction]) {
			sender.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
			sender.alpha = 0.6
		}
	}

	@objc private func buttonTouchUp(_ sender: UIButton) {
		// Reset visual state with smooth spring animation
		UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [.curveEaseInOut, .allowUserInteraction]) {
			sender.transform = .identity
			sender.alpha = 1.0
		}
	}
}
