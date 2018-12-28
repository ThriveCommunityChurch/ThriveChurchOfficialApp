//
//  SermonsCollectionViewCell.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/19/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

class SermonsCollectionViewCell: UICollectionViewCell {
    
	let seriesArt: UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		image.contentMode = .scaleAspectFill
		image.clipsToBounds = true
		return image
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		SetupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func SetupViews() {
		addSubview(seriesArt)
		
		// constraints for the series art view
		NSLayoutConstraint.activate([
			seriesArt.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			seriesArt.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			seriesArt.topAnchor.constraint(equalTo: self.topAnchor),
			seriesArt.bottomAnchor.constraint(equalTo: self.bottomAnchor)
			]
		)
	}
}
