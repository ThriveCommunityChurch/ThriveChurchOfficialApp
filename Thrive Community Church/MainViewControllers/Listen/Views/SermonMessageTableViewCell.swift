//
//  SermonMessageTableViewCell.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/28/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

class SermonMessageTableViewCell: UITableViewCell {

	let title: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Book", size: 14)
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let speaker: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Light", size: 13)
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let date: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Light", size: 13)
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let weekNum: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Avenir-Light", size: 11)
		label.textColor = .lightGray
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let wk: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Avenir-Light", size: 6)
		label.textColor = .lightGray
		label.textAlignment = .center
		label.text = "WK"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let durationLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Avenir-Light", size: 12)
		label.textColor = .lightGray
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let watchImage: UIImageView = {
		let image = UIImageView()
		image.clipsToBounds = true
		image.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
		image.translatesAutoresizingMaskIntoConstraints = false
		image.contentMode = .scaleAspectFill
		image.image = UIImage(named: "videoPlayer")
		return image
	}()
	
	let listenImage: UIImageView = {
		let image = UIImageView()
		image.clipsToBounds = true
		image.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
		image.translatesAutoresizingMaskIntoConstraints = false
		image.contentMode = .scaleAspectFill
		image.image = UIImage(named: "audioPlayer")
		return image
	}()
	
	let downloadSpinner: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		indicator.color = .white
		indicator.backgroundColor = .clear
		indicator.translatesAutoresizingMaskIntoConstraints = false
		return indicator
	}()
	
	override init(style: SermonMessageTableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.translatesAutoresizingMaskIntoConstraints = true
		self.heightAnchor.constraint(equalToConstant: 90).isActive = true
		self.backgroundColor = UIColor.almostBlack
		
		self.setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.setupViews()
	}
	
	func setupViews() {
		
		// add all the views to the main view
		self.addSubview(weekNum)
		self.addSubview(title)
		self.addSubview(wk)
		self.addSubview(date)
		self.addSubview(speaker)
		self.addSubview(watchImage)
		self.addSubview(listenImage)
		self.addSubview(durationLabel)
		self.addSubview(downloadSpinner)
		
		NSLayoutConstraint.activate([
			weekNum.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
			weekNum.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			weekNum.widthAnchor.constraint(equalToConstant: 12),
			wk.centerXAnchor.constraint(equalTo: weekNum.centerXAnchor),
			wk.bottomAnchor.constraint(equalTo: weekNum.topAnchor, constant: 2),
			wk.widthAnchor.constraint(equalTo: weekNum.widthAnchor),
			title.leadingAnchor.constraint(equalTo: weekNum.trailingAnchor, constant: 12),
			title.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
			title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
			date.leadingAnchor.constraint(equalTo: title.leadingAnchor),
			date.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6),
			speaker.leadingAnchor.constraint(equalTo: title.leadingAnchor),
			speaker.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 6),
			watchImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -56),
			watchImage.centerYAnchor.constraint(equalTo: date.centerYAnchor),
			watchImage.heightAnchor.constraint(equalToConstant: 20),
			watchImage.widthAnchor.constraint(equalToConstant: 20),
			listenImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
			listenImage.centerYAnchor.constraint(equalTo: date.centerYAnchor),
			listenImage.heightAnchor.constraint(equalToConstant: 20),
			listenImage.widthAnchor.constraint(equalToConstant: 20),
			durationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
			durationLabel.widthAnchor.constraint(equalToConstant: 45),
			durationLabel.centerYAnchor.constraint(equalTo: speaker.centerYAnchor),
			downloadSpinner.centerYAnchor.constraint(equalTo: date.centerYAnchor),
			downloadSpinner.heightAnchor.constraint(equalToConstant: 22),
			downloadSpinner.widthAnchor.constraint(equalToConstant: 22),
			downloadSpinner.trailingAnchor.constraint(equalTo: watchImage.leadingAnchor, constant: -24)
		])
	}
}
