//
//  OnboardingControllerExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 7/15/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

// Cleaning up the Controller class
extension OnboardingController {
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		// using coordinator to preserve the index of the item for the page that we are on
		// while transitioning this fires
		coordinator.animate(alongsideTransition: { (_) in
			self.collectionViewLayout.invalidateLayout()
			
			// Check for issues with the pages & correct them - namely the first page
			if self.pageControl.currentPage == 0 {
				self.collectionView?.contentOffset = .zero
			}
				// small bug here on iPhone 8 when turning to landscape and back on the third page
			else {
				// scroll to correct index while transitioning
				let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
				self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
			}
		}) { (_) in
		}
	}
	
	
	// add spacing function for the cells to display properly w/out the while line
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
		UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	// section - An index number identifying a section in collectionView.
	override func collectionView(_ collectionView: UICollectionView,
								 numberOfItemsInSection section: Int) -> Int {
		return pages.count
	}
	
	// add cells for the sections above
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt
		indexPath: IndexPath) -> UICollectionViewCell {
		
		// access PageCell items - CASTING is important
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId",
													  for: indexPath) as! OnboardingCell
		/*
		# of the row in the collection View
		following the modulo if the index path is divisibly by 2 then set the color to red else green
		nice little inline coonditionals using an optional *!!THIS IS IMPORTANT!!*
		
		cell.backgroundColor = indexPath.item % 2 == 0 ? .red : .green
		*/
		
		// changes the image of the image view declared in bearImageView to change it based
		// on the image found at the name in the global struct of Pages
		let page = pages[indexPath.item]
		cell.page = page // Swiping sets this page property
		
		return cell
	}
	
	// set the collection view to take the entire size of the screen
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
		UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: view.frame.height)
	}
}

