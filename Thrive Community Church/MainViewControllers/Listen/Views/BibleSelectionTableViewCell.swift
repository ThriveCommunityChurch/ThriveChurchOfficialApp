//
//  BibleSelectionTableViewCell.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 5/3/20.
//  Copyright © 2020 Thrive Community Church. All rights reserved.
//

import UIKit

class BibleSelectionTableViewCell: UITableViewCell {

	
	// UI Elements
	let cellText: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Avenir-Medium", size: 16)
		label.textColor = .white
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		return label
	}()
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
		
		self.backgroundColor = UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1.0)
		
		self.addSubview(cellText)
		
		NSLayoutConstraint.activate([
			cellText.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			cellText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
			cellText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
		])
    }

}
