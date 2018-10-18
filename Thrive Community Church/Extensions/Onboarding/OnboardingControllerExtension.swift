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
		coordinator.animate(alongsideTransition: { (_) in
			self.collectionViewLayout.invalidateLayout()
			
			// Check for issues with the pages & correct them
			if self.pageControl.currentPage == 0 {
				self.collectionView?.contentOffset = .zero
			}
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
	
	override func collectionView(_ collectionView: UICollectionView,
								 numberOfItemsInSection section: Int) -> Int {
		return pages.count
	}
	
	// add cells for the sections above
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt
		indexPath: IndexPath) -> UICollectionViewCell {
		
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId",
														 for: indexPath) as? OnboardingCell {
			
			// changes the image of the image view declared in bearImageView to change it based
			// on the image found at the name in the global struct of Pages
			let page = pages[indexPath.item]
			cell.page = page // Swiping sets this page property
			
			return cell
		}
		else {
			return UICollectionViewCell()
		}
	}
	
	// set the collection view to take the entire size of the screen
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
		UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		return CGSize(width: view.frame.width, height: view.frame.height)
		
	}
	
}
