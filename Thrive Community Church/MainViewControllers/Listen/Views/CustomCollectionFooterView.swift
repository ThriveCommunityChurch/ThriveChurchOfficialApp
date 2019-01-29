//
//  CustomCollectionFooterView.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 1/22/19.
//  Copyright © 2019 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class CustomFooterView : UICollectionReusableView {
	
	@IBOutlet weak var refreshControlIndicator: UIActivityIndicatorView!
	var isAnimatingFinal: Bool = false
	var currentTransform: CGAffineTransform?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.prepareInitialAnimation()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	func setTransform(inTransform:CGAffineTransform, scaleFactor:CGFloat) {
		if isAnimatingFinal {
			return
		}
		self.currentTransform = inTransform
		self.refreshControlIndicator?.transform = CGAffineTransform.init(scaleX: scaleFactor, y: scaleFactor)
	}
	
	// reset the animation
	func prepareInitialAnimation() {
		self.isAnimatingFinal = false
		self.refreshControlIndicator?.stopAnimating()
		self.refreshControlIndicator?.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
	}
	
	func startAnimate() {
		self.isAnimatingFinal = true
		self.refreshControlIndicator?.startAnimating()
	}
	
	func stopAnimate() {
		self.isAnimatingFinal = false
		self.refreshControlIndicator?.stopAnimating()
	}
	
	// final animation to display loading
	func animateFinal() {
		if isAnimatingFinal {
			return
		}
		self.isAnimatingFinal = true
		UIView.animate(withDuration: 0.2) {
			self.refreshControlIndicator?.transform = CGAffineTransform.identity
		}
	}
}

