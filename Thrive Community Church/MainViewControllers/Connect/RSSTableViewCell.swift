//
//  RSSTableViewCell.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 2/24/21.
//  Copyright © 2021 Thrive Community Church. All rights reserved.
//

import UIKit

class RSSTableViewCell: UITableViewCell {
	
	let title: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Book", size: 14)
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let date: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Medium", size: 12)
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	override init(style: RSSTableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.backgroundColor = UIColor.almostBlack
		self.accessoryType = .disclosureIndicator
		
		self.setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.backgroundColor = UIColor.almostBlack
		self.accessoryType = .disclosureIndicator
		
		self.setupViews()
	}
	
	func setupViews() {
		
		// add all the views to the main view
		self.addSubview(title)
		self.addSubview(date)
		
		NSLayoutConstraint.activate([
			title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
			title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
			title.centerYAnchor.constraint(lessThanOrEqualTo: self.centerYAnchor, constant: -15),
			date.centerYAnchor.constraint(lessThanOrEqualTo: self.centerYAnchor, constant: 15),
			date.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8)
		])
	}

}
