//
//  SermonsCollectionViewCell.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/19/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

class SermonsCollectionViewCell: UICollectionViewCell {

	// MARK: - UI Elements

	// Card Container
	private let cardContainer: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.layer.cornerRadius = 12
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOffset = CGSize(width: 0, height: 2)
		view.layer.shadowRadius = 4
		view.layer.shadowOpacity = 0.3
		view.layer.masksToBounds = false
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	let seriesArt: UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		image.contentMode = .scaleAspectFill
		image.clipsToBounds = true
		image.layer.cornerRadius = 12
		image.backgroundColor = .darkGrey // Placeholder color while loading
		return image
	}()

	// Loading indicator for image loading
	private let loadingIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView(style: .medium)
		indicator.color = .white
		indicator.backgroundColor = UIColor.black.withAlphaComponent(0.3)
		indicator.layer.cornerRadius = 8
		indicator.translatesAutoresizingMaskIntoConstraints = false
		indicator.hidesWhenStopped = true
		return indicator
	}()

	// MARK: - Initialization

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Setup Methods

	private func setupViews() {
		backgroundColor = .clear

		// Add card container
		contentView.addSubview(cardContainer)

		// Add series artwork to card container
		cardContainer.addSubview(seriesArt)

		// Add loading indicator
		seriesArt.addSubview(loadingIndicator)
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			// Card Container - with margins for spacing
			cardContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
			cardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			cardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			cardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

			// Series Art - fills card container
			seriesArt.topAnchor.constraint(equalTo: cardContainer.topAnchor),
			seriesArt.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor),
			seriesArt.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor),
			seriesArt.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor),

			// Loading Indicator - centered
			loadingIndicator.centerXAnchor.constraint(equalTo: seriesArt.centerXAnchor),
			loadingIndicator.centerYAnchor.constraint(equalTo: seriesArt.centerYAnchor),
			loadingIndicator.widthAnchor.constraint(equalToConstant: 40),
			loadingIndicator.heightAnchor.constraint(equalToConstant: 40)
		])
	}

	// MARK: - Public Methods

	func showLoadingState() {
		loadingIndicator.startAnimating()
		// Don't clear the image here to avoid flashing
	}

	func hideLoadingState() {
		loadingIndicator.stopAnimating()
	}

	func loadImageWithCompletion(resourceUrl: String, completion: @escaping (Bool) -> Void) {
		// Clear any existing image first
		seriesArt.image = nil

		let url = URL(string: resourceUrl)
		guard let imageUrl = url else {
			completion(false)
			return
		}

		URLSession.shared.dataTask(with: imageUrl) { [weak self] (data, response, error) in
			// Handle errors
			if error != nil {
				print("Image loading error: \(error!)")
				completion(false)
				return
			}

			guard let imageData = data, let image = UIImage(data: imageData) else {
				completion(false)
				return
			}

			DispatchQueue.main.async { [weak self] in
				// Set the image
				self?.seriesArt.image = image

				// Cache the image
				let imageDict = [resourceUrl: image]
				ImageCache.sharedInstance.addImagesToCache(imageData: imageDict)

				// Notify completion
				completion(true)
			}
		}.resume()
	}

	// MARK: - Cell Lifecycle

	override func prepareForReuse() {
		super.prepareForReuse()
		// Clear image and hide loading state immediately
		seriesArt.image = nil
		hideLoadingState()
	}

	// MARK: - Touch Animation

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		animatePress(pressed: true)
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		animatePress(pressed: false)
	}

	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesCancelled(touches, with: event)
		animatePress(pressed: false)
	}

	private func animatePress(pressed: Bool) {
		UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction) {
			self.transform = pressed ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
			self.cardContainer.layer.shadowOpacity = pressed ? 0.1 : 0.3
		}
	}
}
