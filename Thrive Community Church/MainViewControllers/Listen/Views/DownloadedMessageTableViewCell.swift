//
//  DownloadedMessageTableViewCell.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 1/6/19.
//  Copyright © 2019 Thrive Community Church. All rights reserved.
//

import UIKit

class DownloadedMessageTableViewCell: UITableViewCell {
	
	// UI Elements
	let titleLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Book", size: 14)
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let dateLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Light", size: 14)
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let speakerLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Light", size: 14)
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// override init methods
	override init(style: DownloadedMessageTableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.translatesAutoresizingMaskIntoConstraints = true
		self.heightAnchor.constraint(equalToConstant: 50).isActive = true
		self.backgroundColor = UIColor.almostBlack
		
		self.setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.setupViews()
	}
	
	func setupViews() {
		
		// adding subviews
		self.addSubview(titleLabel)
		self.addSubview(dateLabel)
		self.addSubview(speakerLabel)
		
		// add constraints
		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
			titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
			dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
			dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
			dateLabel.widthAnchor.constraint(equalToConstant: 50),
			
		])
		
	}

}
