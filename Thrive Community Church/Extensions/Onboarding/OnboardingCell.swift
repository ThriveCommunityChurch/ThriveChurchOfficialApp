//
//  OnboardingCell.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 7/15/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
	
	let lightGray = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
	
	var page: Page? {
		didSet {
			// use a guard to avoid a crash from forced unwrapping the name if it's nil
			guard let unwrappedPage = page else { return }
			bearImageView.image = UIImage(named: unwrappedPage.imageName)
			
			let attributedText = NSMutableAttributedString(string: unwrappedPage.headerText,
														   attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18),
																		NSAttributedStringKey.foregroundColor: UIColor.white])
			
			attributedText.append(NSAttributedString(string: "\n\n\n\(unwrappedPage.bodyText)",
				attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
							 NSAttributedStringKey.foregroundColor: lightGray]))
			
			textDescriptor.attributedText = attributedText
			textDescriptor.textAlignment = .center
		}
	}
	
	private let bearImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private let textDescriptor: UITextView = {
		let textView = UITextView()
		textView.textAlignment = .center
		textView.isEditable = false
		textView.isScrollEnabled = false
		textView.translatesAutoresizingMaskIntoConstraints = false
		return textView
	}()
	
	// MARK: INIT
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupLayout()
	}
	
	// This is required and will throw any fatal errors
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func setupLayout() {
		let topImageContainerView = UIView()
		addSubview(topImageContainerView)
		
		topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			// change this for more image room
			topImageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.60),
			topImageContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
			// Leading anchors instead - Because the left / right is strange in some rare cases
			topImageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
			topImageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
		
		// add before constraints to avoid a NSGenericException
		topImageContainerView.addSubview(bearImageView)
		addSubview(textDescriptor)
		
		textDescriptor.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
		
		NSLayoutConstraint.activate([
			bearImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
			bearImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor),
			bearImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.40),
			textDescriptor.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor),
			textDescriptor.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
			textDescriptor.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
			textDescriptor.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
	
}
