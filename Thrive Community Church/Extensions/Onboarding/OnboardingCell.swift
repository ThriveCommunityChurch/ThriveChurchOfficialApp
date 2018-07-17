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
			
			// New way of assigning text attributes using a Dict
			let attributedText = NSMutableAttributedString(string: unwrappedPage.headerText,
														   attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18),
																		NSAttributedStringKey.foregroundColor: UIColor.white])
			
			// Add more text to the end of the above text using String Interpilation
			attributedText.append(NSAttributedString(string: "\n\n\n\(unwrappedPage.bodyText)",
				attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
							 NSAttributedStringKey.foregroundColor: lightGray]))
			
			textDescriptor.attributedText = attributedText
			textDescriptor.textAlignment = .center
		}
	}
	
	// Adding a closure for the bear image view
	private let bearImageView: UIImageView = {
		let imageView = UIImageView(image: #imageLiteral(resourceName: "ThriveFGCU"))
		
		// enables AutoLayout
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit // fit aspect for landscape + portrait
		return imageView
	}()
	
	// init of the fields, do not enter the text yet that will be seeon on screen
	private let textDescriptor: UITextView = {
		let textView = UITextView()
		
		// New way of assigning text attributes using a Dict
		let attributedText = NSMutableAttributedString(string: "",
													   attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),
																	NSAttributedStringKey.foregroundColor: UIColor.white])
		
		// Add more text to the end of the above text
		attributedText.append(NSAttributedString(string: "",
												 attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
															  NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
		textView.attributedText = attributedText
		textView.textAlignment = .center // centered
		textView.isEditable = false
		textView.isScrollEnabled = false
		textView.translatesAutoresizingMaskIntoConstraints = false
		return textView
	}()
	
	// register the custom cell
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupLayout()
	}
	
	// required for code to compile - throws error if something bad happens 'mkay
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func setupLayout() {
		// Add container to the top to make the graphic look nice
		let topImageContainerView = UIView()
		addSubview(topImageContainerView)
		
		// enable autoLayout
		topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			topImageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5), // 0.5 = half the height
			topImageContainerView.topAnchor.constraint(equalTo: topAnchor),
			
			// Leading anchors instead - Because the left / right is strange in some rare cases
			topImageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
			topImageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
		
		// This also must be added to the view BEFORE constraints can be added to it
		// otherwise you get an uncaught NSGenericException
		topImageContainerView.addSubview(bearImageView) //add image as a subview to the halved view
		addSubview(textDescriptor)
		
		// set the view to be transparent
		textDescriptor.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
		
		NSLayoutConstraint.activate([
			// set constraints for X + Y
			bearImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
			bearImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor),
			
			// add height / width constraints
			bearImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4), // Half the height of the top view
			
			
			// Add text constrints
			textDescriptor.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor),
			textDescriptor.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
			
			// constant on right / opposite must be negative
			textDescriptor.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
			textDescriptor.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}

