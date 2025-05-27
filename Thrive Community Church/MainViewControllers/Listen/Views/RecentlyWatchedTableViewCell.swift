//
//  RecentlyWatchedTableViewCell.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 1/16/19.
//  Copyright © 2019 Thrive Community Church. All rights reserved.
//

import UIKit

class RecentlyWatchedTableViewCell: UITableViewCell {

	let title: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Book", size: 13)
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let speaker: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Light", size: 11)
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let date: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Light", size: 12)
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let passageRef: UILabel = {
		let label = UILabel()
		label.textAlignment = .right
		label.font = UIFont(name: "Avenir-Light", size: 12)
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	/// TODO: Use the nail icon here if possible
	let seriesArt: UIImageView = {
		let image = UIImageView()
		image.clipsToBounds = true
		image.translatesAutoresizingMaskIntoConstraints = false
		image.contentMode = .scaleAspectFill
		return image
	}()

	override init(style: RecentlyWatchedTableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		// if the device width is below some value then we need to change this

		self.translatesAutoresizingMaskIntoConstraints = true
		// Set height constraint with lower priority to avoid conflicts with table view's automatic sizing
		let heightConstraint = self.heightAnchor.constraint(equalToConstant: 80)
		heightConstraint.priority = UILayoutPriority(999)
		heightConstraint.isActive = true
		self.backgroundColor = UIColor.almostBlack

		self.setupViews()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		self.setupViews()
	}

	func setupViews() {

		// add all the views to the main view
		self.addSubview(seriesArt)
		self.addSubview(title)
		self.addSubview(date)
		self.addSubview(passageRef)
		self.addSubview(speaker)

		NSLayoutConstraint.activate([
			seriesArt.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			seriesArt.topAnchor.constraint(equalTo: self.topAnchor),
			seriesArt.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			seriesArt.widthAnchor.constraint(equalToConstant: 142),
			title.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
			title.leadingAnchor.constraint(equalTo: seriesArt.trailingAnchor, constant: 8),
			title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
			date.leadingAnchor.constraint(equalTo: title.leadingAnchor),
			date.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
			speaker.leadingAnchor.constraint(equalTo: title.leadingAnchor),
			speaker.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 8),
			passageRef.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
			passageRef.centerYAnchor.constraint(equalTo: speaker.centerYAnchor),
			speaker.trailingAnchor.constraint(equalTo: passageRef.leadingAnchor, constant: -16)
		])
	}

}
