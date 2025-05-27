//
//  ViewPlayerViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/24/19.
//  Copyright © 2019 Thrive Community Church. All rights reserved.
//

import UIKit
import AVFoundation
import WebKit

public class ViewPlayerViewController: UIViewController, WKNavigationDelegate {

	// MARK: - Properties
	public var VideoId: String = "" {
		didSet {
			self.videoId = VideoId
		}
	}

	public var Message: SermonMessage! {
		didSet {
			self.message = Message
		}
	}

	fileprivate var videoId: String = ""
	fileprivate var message: SermonMessage!

	// MARK: - State Management
	private var isSermonInfoExpanded = false
	private var isBiblePassageExpanded = false


	// MARK: - UI Elements

	// Video Player Container
	private let videoPlayerContainer: UIView = {
		let view = UIView()
		view.backgroundColor = .black
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 12
		view.clipsToBounds = true
		return view
	}()

	// Loading and Progress Elements
	private let loadingSpinner: UIActivityIndicatorView = {
		let spinner = UIActivityIndicatorView(style: .large)
		spinner.color = .white
		spinner.backgroundColor = UIColor.black.withAlphaComponent(0.6)
		spinner.layer.cornerRadius = 8
		spinner.translatesAutoresizingMaskIntoConstraints = false
		return spinner
	}()

	private let progressView: UIProgressView = {
		let progress = UIProgressView(progressViewStyle: .default)
		progress.tintColor = .mainBlue
		progress.backgroundColor = .darkGray
		progress.translatesAutoresizingMaskIntoConstraints = false
		return progress
	}()

	// Main Content Scroll View
	private let scrollView: UIScrollView = {
		let scroll = UIScrollView()
		scroll.translatesAutoresizingMaskIntoConstraints = false
		scroll.showsVerticalScrollIndicator = true
		scroll.alwaysBounceVertical = true
		return scroll
	}()

	private let contentView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	// Sermon Title Section
	private let sermonTitleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Avenir-Heavy", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .heavy)
		label.textColor = .white
		label.numberOfLines = 0
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private let seriesLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Avenir-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
		label.textColor = .mainBlue
		label.numberOfLines = 0
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// Sermon Info Expandable Section
	private let sermonInfoHeaderView: UIView = {
		let view = UIView()
		view.backgroundColor = .darkGrey
		view.layer.cornerRadius = 8
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private let sermonInfoTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "Sermon Information"
		label.font = UIFont(name: "Avenir-Heavy", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .heavy)
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private let sermonInfoChevron: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "chevron.down")
		imageView.tintColor = .lightGray
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private let sermonInfoContentView: UIView = {
		let view = UIView()
		view.backgroundColor = .almostBlack
		view.layer.cornerRadius = 8
		view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
		view.translatesAutoresizingMaskIntoConstraints = false
		view.isHidden = true
		return view
	}()

	// Sermon Info Detail Labels
	private let speakerInfoView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.spacing = 12
		stack.alignment = .center
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()

	private let speakerIcon: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "person.circle.fill")
		imageView.tintColor = .mainBlue
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private let speakerLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Avenir-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private let dateInfoView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.spacing = 12
		stack.alignment = .center
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()

	private let dateIcon: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "calendar.circle.fill")
		imageView.tintColor = .mainBlue
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private let dateLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Avenir-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// Bible Passage Expandable Section
	private let biblePassageHeaderView: UIView = {
		let view = UIView()
		view.backgroundColor = .darkGrey
		view.layer.cornerRadius = 8
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private let biblePassageTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "Bible Passage"
		label.font = UIFont(name: "Avenir-Heavy", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .heavy)
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private let biblePassageChevron: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "chevron.down")
		imageView.tintColor = .lightGray
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private let biblePassageContentView: UIView = {
		let view = UIView()
		view.backgroundColor = .almostBlack
		view.layer.cornerRadius = 8
		view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
		view.translatesAutoresizingMaskIntoConstraints = false
		view.isHidden = true
		return view
	}()

	private let passageReferenceLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Avenir-Heavy", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .heavy)
		label.textColor = .mainBlue
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private let readPassageButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Read Full Passage", for: .normal)
		button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .mainBlue
		button.layer.cornerRadius = 8
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	// WebView for video
	private var webView: WKWebView = WKWebView()

	// MARK: - Lifecycle
	override public func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
		setupActions()
		loadSermonData()
    }

	override public func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK: - Setup Methods
	private func setupViews() {
		view.backgroundColor = .almostBlack
		setupNavigationBar()
		setupScrollView()
		setupVideoPlayer()
		setupContentSections()
		setupConstraints()
	}

	private func setupNavigationBar() {
		let openYTButton = UIBarButtonItem(
			image: UIImage(named: "youtube")?.withRenderingMode(.alwaysOriginal),
			style: .plain,
			target: self,
			action: #selector(watchOnYT)
		)
		navigationItem.rightBarButtonItem = openYTButton

		// Set navigation title
		title = "Watch Sermon"
	}

	private func setupScrollView() {
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)

		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
		])
	}

	private func setupVideoPlayer() {
		contentView.addSubview(videoPlayerContainer)
		videoPlayerContainer.addSubview(loadingSpinner)
		videoPlayerContainer.addSubview(progressView)

		// Start loading animation
		loadingSpinner.startAnimating()
		progressView.isHidden = true
	}

	private func setupContentSections() {
		// Add main content elements
		contentView.addSubview(sermonTitleLabel)
		contentView.addSubview(seriesLabel)

		// Setup sermon info section
		setupSermonInfoSection()

		// Setup bible passage section
		setupBiblePassageSection()
	}

	private func setupSermonInfoSection() {
		contentView.addSubview(sermonInfoHeaderView)
		contentView.addSubview(sermonInfoContentView)

		// Header elements
		sermonInfoHeaderView.addSubview(sermonInfoTitleLabel)
		sermonInfoHeaderView.addSubview(sermonInfoChevron)

		// Content elements
		sermonInfoContentView.addSubview(speakerInfoView)
		sermonInfoContentView.addSubview(dateInfoView)

		// Setup speaker info stack
		speakerInfoView.addArrangedSubview(speakerIcon)
		speakerInfoView.addArrangedSubview(speakerLabel)

		// Setup date info stack
		dateInfoView.addArrangedSubview(dateIcon)
		dateInfoView.addArrangedSubview(dateLabel)
	}

	private func setupBiblePassageSection() {
		contentView.addSubview(biblePassageHeaderView)
		contentView.addSubview(biblePassageContentView)

		// Header elements
		biblePassageHeaderView.addSubview(biblePassageTitleLabel)
		biblePassageHeaderView.addSubview(biblePassageChevron)

		// Content elements
		biblePassageContentView.addSubview(passageReferenceLabel)
		biblePassageContentView.addSubview(readPassageButton)
	}

	private func setupConstraints() {
		let margins = contentView.layoutMarginsGuide

		NSLayoutConstraint.activate([
			// Video Player Container - 16:9 aspect ratio
			videoPlayerContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
			videoPlayerContainer.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			videoPlayerContainer.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
			videoPlayerContainer.heightAnchor.constraint(equalTo: videoPlayerContainer.widthAnchor, multiplier: 9.0/16.0),

			// Loading Spinner
			loadingSpinner.centerXAnchor.constraint(equalTo: videoPlayerContainer.centerXAnchor),
			loadingSpinner.centerYAnchor.constraint(equalTo: videoPlayerContainer.centerYAnchor),
			loadingSpinner.widthAnchor.constraint(equalToConstant: 80),
			loadingSpinner.heightAnchor.constraint(equalToConstant: 80),

			// Progress View
			progressView.leadingAnchor.constraint(equalTo: videoPlayerContainer.leadingAnchor),
			progressView.trailingAnchor.constraint(equalTo: videoPlayerContainer.trailingAnchor),
			progressView.bottomAnchor.constraint(equalTo: videoPlayerContainer.bottomAnchor),
			progressView.heightAnchor.constraint(equalToConstant: 3),

			// Sermon Title
			sermonTitleLabel.topAnchor.constraint(equalTo: videoPlayerContainer.bottomAnchor, constant: 24),
			sermonTitleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			sermonTitleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

			// Series Label
			seriesLabel.topAnchor.constraint(equalTo: sermonTitleLabel.bottomAnchor, constant: 8),
			seriesLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			seriesLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
		])

		setupSermonInfoConstraints()
		setupBiblePassageConstraints()
	}

	private func setupSermonInfoConstraints() {
		let margins = contentView.layoutMarginsGuide

		NSLayoutConstraint.activate([
			// Sermon Info Header
			sermonInfoHeaderView.topAnchor.constraint(equalTo: seriesLabel.bottomAnchor, constant: 32),
			sermonInfoHeaderView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			sermonInfoHeaderView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
			sermonInfoHeaderView.heightAnchor.constraint(equalToConstant: 56),

			// Header Title
			sermonInfoTitleLabel.leadingAnchor.constraint(equalTo: sermonInfoHeaderView.leadingAnchor, constant: 16),
			sermonInfoTitleLabel.centerYAnchor.constraint(equalTo: sermonInfoHeaderView.centerYAnchor),

			// Header Chevron
			sermonInfoChevron.trailingAnchor.constraint(equalTo: sermonInfoHeaderView.trailingAnchor, constant: -16),
			sermonInfoChevron.centerYAnchor.constraint(equalTo: sermonInfoHeaderView.centerYAnchor),
			sermonInfoChevron.widthAnchor.constraint(equalToConstant: 20),
			sermonInfoChevron.heightAnchor.constraint(equalToConstant: 20),

			// Content View
			sermonInfoContentView.topAnchor.constraint(equalTo: sermonInfoHeaderView.bottomAnchor),
			sermonInfoContentView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			sermonInfoContentView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

			// Speaker Info
			speakerInfoView.topAnchor.constraint(equalTo: sermonInfoContentView.topAnchor, constant: 20),
			speakerInfoView.leadingAnchor.constraint(equalTo: sermonInfoContentView.leadingAnchor, constant: 16),
			speakerInfoView.trailingAnchor.constraint(equalTo: sermonInfoContentView.trailingAnchor, constant: -16),

			// Speaker Icon
			speakerIcon.widthAnchor.constraint(equalToConstant: 24),
			speakerIcon.heightAnchor.constraint(equalToConstant: 24),

			// Date Info
			dateInfoView.topAnchor.constraint(equalTo: speakerInfoView.bottomAnchor, constant: 16),
			dateInfoView.leadingAnchor.constraint(equalTo: sermonInfoContentView.leadingAnchor, constant: 16),
			dateInfoView.trailingAnchor.constraint(equalTo: sermonInfoContentView.trailingAnchor, constant: -16),
			dateInfoView.bottomAnchor.constraint(equalTo: sermonInfoContentView.bottomAnchor, constant: -20),

			// Date Icon
			dateIcon.widthAnchor.constraint(equalToConstant: 24),
			dateIcon.heightAnchor.constraint(equalToConstant: 24),
		])
	}

	private func setupBiblePassageConstraints() {
		let margins = contentView.layoutMarginsGuide

		NSLayoutConstraint.activate([
			// Bible Passage Header
			biblePassageHeaderView.topAnchor.constraint(equalTo: sermonInfoContentView.bottomAnchor, constant: 16),
			biblePassageHeaderView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			biblePassageHeaderView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
			biblePassageHeaderView.heightAnchor.constraint(equalToConstant: 56),

			// Header Title
			biblePassageTitleLabel.leadingAnchor.constraint(equalTo: biblePassageHeaderView.leadingAnchor, constant: 16),
			biblePassageTitleLabel.centerYAnchor.constraint(equalTo: biblePassageHeaderView.centerYAnchor),

			// Header Chevron
			biblePassageChevron.trailingAnchor.constraint(equalTo: biblePassageHeaderView.trailingAnchor, constant: -16),
			biblePassageChevron.centerYAnchor.constraint(equalTo: biblePassageHeaderView.centerYAnchor),
			biblePassageChevron.widthAnchor.constraint(equalToConstant: 20),
			biblePassageChevron.heightAnchor.constraint(equalToConstant: 20),

			// Content View
			biblePassageContentView.topAnchor.constraint(equalTo: biblePassageHeaderView.bottomAnchor),
			biblePassageContentView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			biblePassageContentView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
			biblePassageContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),

			// Passage Reference
			passageReferenceLabel.topAnchor.constraint(equalTo: biblePassageContentView.topAnchor, constant: 20),
			passageReferenceLabel.leadingAnchor.constraint(equalTo: biblePassageContentView.leadingAnchor, constant: 16),
			passageReferenceLabel.trailingAnchor.constraint(equalTo: biblePassageContentView.trailingAnchor, constant: -16),

			// Read Passage Button
			readPassageButton.topAnchor.constraint(equalTo: passageReferenceLabel.bottomAnchor, constant: 16),
			readPassageButton.leadingAnchor.constraint(equalTo: biblePassageContentView.leadingAnchor, constant: 16),
			readPassageButton.trailingAnchor.constraint(equalTo: biblePassageContentView.trailingAnchor, constant: -16),
			readPassageButton.heightAnchor.constraint(equalToConstant: 44),
			readPassageButton.bottomAnchor.constraint(equalTo: biblePassageContentView.bottomAnchor, constant: -20),
		])
	}

	// MARK: - Actions
	private func setupActions() {
		// Add tap gestures for expandable sections
		let sermonInfoTap = UITapGestureRecognizer(target: self, action: #selector(toggleSermonInfo))
		sermonInfoHeaderView.addGestureRecognizer(sermonInfoTap)

		let biblePassageTap = UITapGestureRecognizer(target: self, action: #selector(toggleBiblePassage))
		biblePassageHeaderView.addGestureRecognizer(biblePassageTap)

		// Add button actions
		readPassageButton.addTarget(self, action: #selector(readFullPassage), for: .touchUpInside)
	}

	@objc private func toggleSermonInfo() {
		isSermonInfoExpanded.toggle()

		UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
			self.sermonInfoContentView.isHidden = !self.isSermonInfoExpanded
			self.sermonInfoChevron.transform = self.isSermonInfoExpanded ?
				CGAffineTransform(rotationAngle: .pi) : .identity
		}
	}

	@objc private func toggleBiblePassage() {
		isBiblePassageExpanded.toggle()

		UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
			self.biblePassageContentView.isHidden = !self.isBiblePassageExpanded
			self.biblePassageChevron.transform = self.isBiblePassageExpanded ?
				CGAffineTransform(rotationAngle: .pi) : .identity
		}
	}

	@objc private func readFullPassage() {
		guard let passageRef = message?.PassageRef, !passageRef.isEmpty else { return }

		// Navigate to ReadSermonPassageViewController
		let passageVC = ReadSermonPassageViewController()
		passageVC.Passage = passageRef

		// Load the API domain from UserDefaults
		if let apiDomain = UserDefaults.standard.string(forKey: ApplicationVariables.ApiCacheKey) {
			passageVC.API = apiDomain
			navigationController?.pushViewController(passageVC, animated: true)
		} else {
			print("ERROR: Could not load API domain from UserDefaults")
		}
	}

	@objc func watchOnYT() {
		let urlString = "youtube://\(videoId)"

		if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url)
		} else if let url = URL(string: "http://www.youtube.com/watch?v=\(videoId)") {
			UIApplication.shared.open(url)
		}
	}

	// MARK: - Data Loading
	private func loadSermonData() {
		guard let message = message else { return }

		// Load sermon metadata
		sermonTitleLabel.text = message.Title
		seriesLabel.text = message.seriesTitle ?? "Sermon Series"
		speakerLabel.text = message.Speaker
		dateLabel.text = message.Date

		// Load Bible passage reference
		if let passageRef = message.PassageRef, !passageRef.isEmpty {
			passageReferenceLabel.text = passageRef
		} else {
			passageReferenceLabel.text = "No passage reference available"
			readPassageButton.isEnabled = false
			readPassageButton.alpha = 0.5
		}

		// Load video
		loadYoutube(videoID: videoId)
	}

	private func loadYoutube(videoID: String) {
		let configuration = WKWebViewConfiguration()
		configuration.allowsInlineMediaPlayback = true
		configuration.mediaTypesRequiringUserActionForPlayback = []

		guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)?playsinline=1&autoplay=0&rel=0&showinfo=0") else {
			print("Invalid YouTube URL for video ID: \(videoID)")
			return
		}

		// Create WebView with proper configuration
		webView = WKWebView(frame: .zero, configuration: configuration)
		webView.navigationDelegate = self
		webView.translatesAutoresizingMaskIntoConstraints = false
		webView.backgroundColor = .black
		webView.isOpaque = false
		webView.scrollView.isScrollEnabled = false

		// Add WebView to container
		videoPlayerContainer.addSubview(webView)
		videoPlayerContainer.sendSubviewToBack(webView)

		// Setup WebView constraints
		NSLayoutConstraint.activate([
			webView.topAnchor.constraint(equalTo: videoPlayerContainer.topAnchor),
			webView.leadingAnchor.constraint(equalTo: videoPlayerContainer.leadingAnchor),
			webView.trailingAnchor.constraint(equalTo: videoPlayerContainer.trailingAnchor),
			webView.bottomAnchor.constraint(equalTo: videoPlayerContainer.bottomAnchor)
		])

		// Setup progress tracking
		progressView.isHidden = false
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

		// Load the video
		webView.load(URLRequest(url: youtubeURL))
	}

	// MARK: - WKNavigationDelegate
	public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		// Remove progress observer
		webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))

		// Hide loading elements with animation
		UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut) {
			self.loadingSpinner.alpha = 0
			self.progressView.alpha = 0
		} completion: { _ in
			self.loadingSpinner.stopAnimating()
			self.loadingSpinner.isHidden = true
			self.progressView.isHidden = true
		}
	}

	public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		print("WebView failed to load: \(error.localizedDescription)")
		handleVideoLoadError()
	}

	public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		print("WebView failed provisional navigation: \(error.localizedDescription)")
		handleVideoLoadError()
	}

	private func handleVideoLoadError() {
		UIView.animate(withDuration: 0.3) {
			self.loadingSpinner.alpha = 0
			self.progressView.alpha = 0
		} completion: { _ in
			self.loadingSpinner.stopAnimating()
			self.loadingSpinner.isHidden = true
			self.progressView.isHidden = true

			// Show error message
			let errorLabel = UILabel()
			errorLabel.text = "Unable to load video"
			errorLabel.textColor = .lightGray
			errorLabel.textAlignment = .center
			errorLabel.font = UIFont(name: "Avenir-Medium", size: 16)
			errorLabel.translatesAutoresizingMaskIntoConstraints = false

			self.videoPlayerContainer.addSubview(errorLabel)
			NSLayoutConstraint.activate([
				errorLabel.centerXAnchor.constraint(equalTo: self.videoPlayerContainer.centerXAnchor),
				errorLabel.centerYAnchor.constraint(equalTo: self.videoPlayerContainer.centerYAnchor)
			])
		}
	}

	// MARK: - KVO
	override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			DispatchQueue.main.async {
				self.progressView.progress = Float(self.webView.estimatedProgress)
			}
		}
	}

	// MARK: - Memory Management
	deinit {
		// Clean up observers if still active
		if webView.observationInfo != nil {
			webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
		}
	}

}
