//
//  SermonMessageTableViewCell.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/28/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

class SermonMessageTableViewCell: UITableViewCell {

	// MARK: - UI Elements

	// Card Container
	private let cardContainer: UIView = {
		let view = UIView()
		view.backgroundColor = .darkGrey
		view.layer.cornerRadius = 12
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOffset = CGSize(width: 0, height: 2)
		view.layer.shadowRadius = 4
		view.layer.shadowOpacity = 0.3
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	// Week Number Badge - Subtle rectangular design
	private let weekBadge: UIView = {
		let view = UIView()
		view.backgroundColor = .mainBlue.withAlphaComponent(0.2)
		view.layer.cornerRadius = 6
		view.layer.borderWidth = 1
		view.layer.borderColor = UIColor.mainBlue.withAlphaComponent(0.3).cgColor
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	let weekNum: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Avenir-Heavy", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .heavy)
		label.textColor = .mainBlue
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private let weekLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Avenir-Medium", size: 8) ?? UIFont.systemFont(ofSize: 8, weight: .medium)
		label.textColor = .mainBlue.withAlphaComponent(0.8)
		label.textAlignment = .center
		label.text = "WEEK"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// Content Stack View
	private let contentStackView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 8
		stack.alignment = .leading
		stack.distribution = .fill
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()

	// Title
	let title: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Avenir-Heavy", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .heavy)
		label.textColor = .white
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// Metadata Stack View
	private let metadataStackView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 4
		stack.alignment = .leading
		stack.distribution = .fill
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()

	// Speaker Info
	private let speakerInfoView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.spacing = 8
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

	let speaker: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Avenir-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// Date Info
	private let dateInfoView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.spacing = 8
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

	let date: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Avenir-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// Media Status and Duration Container
	private let mediaStatusView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.spacing = 8
		stack.alignment = .center
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()

	// Media Icons - Simple status indicators
	let watchImage: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "play.rectangle")
		imageView.tintColor = .lightGray
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	let listenImage: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "headphones")
		imageView.tintColor = .lightGray
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	// Duration Label
	let durationLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Avenir-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// Download Status
	private let downloadStatusContainer: UIView = {
		let view = UIView()
		view.backgroundColor = .mainBlue
		view.layer.cornerRadius = 12
		view.translatesAutoresizingMaskIntoConstraints = false
		view.isHidden = true
		return view
	}()

	let downloadSpinner: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView(style: .medium)
		indicator.color = .white
		indicator.backgroundColor = .clear
		indicator.translatesAutoresizingMaskIntoConstraints = false
		return indicator
	}()

	private let downloadedIcon: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "checkmark.circle.fill")
		imageView.tintColor = .white
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.isHidden = true
		return imageView
	}()

	// Legacy properties for compatibility
	let wk: UILabel = UILabel() // Hidden, kept for compatibility

	// MARK: - Initialization
	override init(style: SermonMessageTableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupViews()
		setupConstraints()
	}

	// MARK: - Setup Methods
	private func setupViews() {
		backgroundColor = .almostBlack
		selectionStyle = .none

		// Configure cell appearance
		layer.masksToBounds = false

		// Add main container
		contentView.addSubview(cardContainer)

		// Setup week badge
		cardContainer.addSubview(weekBadge)
		weekBadge.addSubview(weekNum)
		weekBadge.addSubview(weekLabel)

		// Setup content stack
		cardContainer.addSubview(contentStackView)
		contentStackView.addArrangedSubview(title)
		contentStackView.addArrangedSubview(metadataStackView)

		// Setup metadata - now includes media status
		metadataStackView.addArrangedSubview(speakerInfoView)
		metadataStackView.addArrangedSubview(dateInfoView)
		metadataStackView.addArrangedSubview(mediaStatusView)

		// Setup speaker info
		speakerInfoView.addArrangedSubview(speakerIcon)
		speakerInfoView.addArrangedSubview(speaker)

		// Setup date info
		dateInfoView.addArrangedSubview(dateIcon)
		dateInfoView.addArrangedSubview(date)

		// Setup media status (moved to bottom with metadata)
		mediaStatusView.addArrangedSubview(watchImage)
		mediaStatusView.addArrangedSubview(listenImage)
		mediaStatusView.addArrangedSubview(durationLabel)

		// Setup download status in top-right corner
		cardContainer.addSubview(downloadStatusContainer)
		downloadStatusContainer.addSubview(downloadSpinner)
		downloadStatusContainer.addSubview(downloadedIcon)

		// Hide legacy element
		wk.isHidden = true
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			// Card Container - Reduced spacing
			cardContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
			cardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			cardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			cardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

			// Week Badge - Smaller rectangular design
			weekBadge.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 16),
			weekBadge.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 16),
			weekBadge.widthAnchor.constraint(equalToConstant: 50),
			weekBadge.heightAnchor.constraint(equalToConstant: 32),

			// Week Number
			weekNum.centerXAnchor.constraint(equalTo: weekBadge.centerXAnchor),
			weekNum.topAnchor.constraint(equalTo: weekBadge.topAnchor, constant: 2),

			// Week Label
			weekLabel.centerXAnchor.constraint(equalTo: weekBadge.centerXAnchor),
			weekLabel.bottomAnchor.constraint(equalTo: weekBadge.bottomAnchor, constant: -2),

			// Content Stack
			contentStackView.leadingAnchor.constraint(equalTo: weekBadge.trailingAnchor, constant: 12),
			contentStackView.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 16),
			contentStackView.trailingAnchor.constraint(equalTo: downloadStatusContainer.leadingAnchor, constant: -12),
			contentStackView.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -16),

			// Speaker Icon
			speakerIcon.widthAnchor.constraint(equalToConstant: 16),
			speakerIcon.heightAnchor.constraint(equalToConstant: 16),

			// Date Icon
			dateIcon.widthAnchor.constraint(equalToConstant: 16),
			dateIcon.heightAnchor.constraint(equalToConstant: 16),

			// Media Icons
			watchImage.widthAnchor.constraint(equalToConstant: 16),
			watchImage.heightAnchor.constraint(equalToConstant: 16),

			listenImage.widthAnchor.constraint(equalToConstant: 16),
			listenImage.heightAnchor.constraint(equalToConstant: 16),

			// Download Status Container - Top right corner
			downloadStatusContainer.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -16),
			downloadStatusContainer.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 16),
			downloadStatusContainer.widthAnchor.constraint(equalToConstant: 24),
			downloadStatusContainer.heightAnchor.constraint(equalToConstant: 24),

			// Download Spinner
			downloadSpinner.centerXAnchor.constraint(equalTo: downloadStatusContainer.centerXAnchor),
			downloadSpinner.centerYAnchor.constraint(equalTo: downloadStatusContainer.centerYAnchor),

			// Downloaded Icon
			downloadedIcon.centerXAnchor.constraint(equalTo: downloadStatusContainer.centerXAnchor),
			downloadedIcon.centerYAnchor.constraint(equalTo: downloadStatusContainer.centerYAnchor),
			downloadedIcon.widthAnchor.constraint(equalToConstant: 16),
			downloadedIcon.heightAnchor.constraint(equalToConstant: 16),
		])
	}

	// MARK: - Media Availability Methods
	func setVideoAvailable(_ available: Bool) {
		if available {
			watchImage.tintColor = .mainBlue
			watchImage.image = UIImage(systemName: "play.rectangle.fill")
		} else {
			watchImage.tintColor = .lightGray.withAlphaComponent(0.5)
			watchImage.image = UIImage(systemName: "play.rectangle")
		}
		watchImage.isHidden = false
	}

	func setAudioAvailable(_ available: Bool) {
		if available {
			listenImage.tintColor = .mainBlue
			listenImage.image = UIImage(systemName: "headphones.circle.fill")
		} else {
			listenImage.tintColor = .lightGray.withAlphaComponent(0.5)
			listenImage.image = UIImage(systemName: "headphones")
		}
		listenImage.isHidden = false
	}

	// MARK: - Public Methods
	func showDownloadProgress() {
		downloadStatusContainer.isHidden = false
		downloadedIcon.isHidden = true
		downloadSpinner.startAnimating()
	}

	func hideDownloadProgress() {
		downloadSpinner.stopAnimating()
		downloadStatusContainer.isHidden = true
	}

	func showDownloadedStatus() {
		downloadStatusContainer.isHidden = false
		downloadSpinner.stopAnimating()
		downloadedIcon.isHidden = false
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		hideDownloadProgress()
		downloadedIcon.isHidden = true

		// Reset media icons to default state
		watchImage.isHidden = true
		listenImage.isHidden = true
		durationLabel.text = ""
		durationLabel.isHidden = true

		// Reset week badge
		weekNum.text = ""

		// Reset content
		title.text = ""
		speaker.text = ""
		date.text = ""
	}
}
