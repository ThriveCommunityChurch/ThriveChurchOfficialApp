//
//  OnboardingController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 7/15/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

// Make your life easier by declaring an OO extension to UIColor for things that are used often
extension UIColor {
	static var mainPink = UIColor(red: 232/255, green: 68/255, blue: 133/255, alpha: 1)
	static var bgPink = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
}

// CONTROLLER
// controls the each cell and how they are controlled
class OnboardingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	// don't just use Arrays - they crash easily if there are too few or many cells vs count
	let pages = [
		Page(imageName: "bear_first",
			 headerText: "Join us today in our Fun & Games!",
			 bodyText: "Are you ready for loads and loads of fun? Don't wait any longer! We hope to see you in our stores soon."),
		Page(imageName: "heart_second",
			 headerText: "Subscribe & get coupons on our daily events",
			 bodyText: "Get notified of the savings imediately when we announce them on our website. Make sure to also give us any feedback you have."),
		Page(imageName: "leaf_third",
			 headerText: "VIP members special services",
			 bodyText: "Join the private club of elite customers and you'll get entered into select drawings & giveaways.")
	]
	
	// Add previous button - private so that no other .swift classes can access this
	private let previousButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("PREV", for: .normal)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
		button.setTitleColor(.gray, for: .normal)
		return button
	}()
	
	// Dots at the bottom for viewing the page we are on & what not
	lazy var pageControl: UIPageControl = {
		let pc = UIPageControl()
		pc.currentPage = 0
		pc.numberOfPages = pages.count // access member of your class thanks to lazy var
		pc.currentPageIndicatorTintColor = UIColor.mainPink
		pc.pageIndicatorTintColor = UIColor.bgPink
		return pc
	}()
	
	// Add previous button - private so that no other .swift classes can access this
	private let nextButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("NEXT", for: .normal)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor(UIColor.mainPink, for: .normal)
		button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
		return button
	}()
	
	// next button handler
	@objc private func handleNext() {
		
		// protect the crash for the 4 pages when 3 are visible
		// uses min so we dont end up on page 4 of 3
		let nextIndex = min(pageControl.currentPage + 1, pages.count - 1) // use the pc value for the value for what page we are on
		
		// at the end
		if pageControl.currentPage == nextIndex {
			self.dismiss(animated: true, completion: nil)
		}
		else {
			pageControl.currentPage = nextIndex // reset value for pc.current
			let indexPath = IndexPath(item: nextIndex, section: 0)
			collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
		}
	}
	
	// previous button handler
	@objc private func handlePrev() {
		
		// protect the crash for the 4 pages when 3 are visible
		// uses max so we dont end up on page -1
		let nextIndex = max(pageControl.currentPage - 1, 0) // use the pc value for the value for what page we are on
		pageControl.currentPage = nextIndex // reset value for pc.current
		let indexPath = IndexPath(item: nextIndex, section: 0)
		collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
	}
	
	override func scrollViewWillEndDragging(_ scrollView: UIScrollView,
											withVelocity velocity: CGPoint,
											targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		let x = targetContentOffset.pointee.x
		let pageID = x / view.frame.width // this is kinda cool
		pageControl.currentPage = Int(pageID) // set the dot to be the current page
	}
	
	// MARK: Start
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupBottomControls()
		
		collectionView?.backgroundColor = .white
		// add this line to prevent NSInternalInconsistencyException & register cells
		collectionView?.register(OnboardingCell.self, forCellWithReuseIdentifier: "cellId") // adding custom View Cell - this is important too
		collectionView?.isPagingEnabled = true // allows for snaps between the cells
		collectionView?.showsHorizontalScrollIndicator = false
	}
	
	//using FilePrivate because the init of the button is private - this preserves the privacy
	fileprivate func setupBottomControls() {
		
		// Using UI Stack view for adding buttons to the bottom - much more effiencent & easy
		let bottomControlsStackView = UIStackView(arrangedSubviews:
			[previousButton, pageControl, nextButton])
		
		bottomControlsStackView.distribution = .fillEqually // Tells the stack view to split
		view.addSubview(bottomControlsStackView)
		
		// enable autoLayout
		bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
		
		// Easier way of activating constraints - I like this more
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
				bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor), // safe for landscape
				bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
			])
		} else {
			// Fallback on earlier versions
			NSLayoutConstraint.activate([
				bottomControlsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				bottomControlsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor), // safe for landscape
				bottomControlsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
			])
		}
	}
}

