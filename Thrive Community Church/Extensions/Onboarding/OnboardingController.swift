//
//  OnboardingController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 7/15/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit
import Firebase

class OnboardingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	var onboardingString = String()

	// simple way to do this is just use an array
	let pages = [
		Page(imageName: "listen_img",
			 headerText: "Take us with you on the go!",
			 bodyText: "Whether you're traveling or under the weather, you'll never miss a sermon series with our automatic weekly updates. Download sermons for listening in the car, at work or at the gym. You can even stream your favorite messages in Full HD!"),
		//Page(imageName: "notes_img",
		//	 headerText: "Your Notes. Your Device.",
		//	 bodyText: "Taking notes during the message has never been easier. Our note taker supports a full Emoji keyboard, for creating notes with beautiful bullited lists. Notes are saved locally on your device, and sending your notes to friends or sharing them online is only one tap away."),
		Page(imageName: "bible_img",
			 headerText: "Read The Entire Bible!",
			 bodyText: "With the power of YouVersion and bible.com, the entire English Standard Version (ESV) of the bible is available at your fingertips. Take your bible with you, wherever you go."),
		Page(imageName: "final_img",
			 headerText: "Ready To Get Started?",
			 bodyText: "Tap DONE below to dive in and experience Thrive Community Church")
	]

	private let previousButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("", for: .normal)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor(UIColor.lessLightLightGray, for: .normal)
		return button
	}()

	// access to self thanks to lazy var
	lazy var pageControl: UIPageControl = {
		let pc = UIPageControl()
		pc.currentPage = 0
		pc.translatesAutoresizingMaskIntoConstraints = false
		pc.numberOfPages = pages.count
		pc.currentPageIndicatorTintColor = UIColor.mainBlue
		pc.pageIndicatorTintColor = UIColor.bgBlue
		return pc
	}()

	private let nextButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("NEXT", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor(UIColor.mainBlue, for: .normal)
		return button
	}()

	private let skipButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Skip", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
		button.setTitleColor(UIColor.lighterBlueGray, for: .normal)
		return button
	}()

	// next button handler
	@objc private func handleNext() {

		// protect the crash for the 4 pages when 3 are visible
		// uses min so we dont end up on page 4 of 3
		let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)

		if nextButton.titleLabel?.text == "DONE" && pageControl.currentPage == pages.count - 1 {
			self.saveForCompletingOnboarding()
		}
		else {
			if pages.count - 1 == nextIndex {
				self.nextButton.setTitle("DONE", for: .normal)
			}
			else {
				self.nextButton.setTitle("NEXT", for: .normal)
			}

			if nextIndex > 0 {
				self.previousButton.setTitle("PREV", for: .normal)
			}

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
	}

	@objc private func handleSkip() {
		self.saveForCompletingOnboarding()
	}


	// previous button handler
	@objc private func handlePrev() {

		// protect the crash for the 4 pages when 3 are visible
		// uses max so we dont end up on page -1
		let nextIndex = max(pageControl.currentPage - 1, 0)
		pageControl.currentPage = nextIndex

		if nextIndex == 0 {
			self.previousButton.setTitle("", for: .normal)
		}
		else {
			self.previousButton.setTitle("PREV", for: .normal)
		}

		if pages.count - 1 == nextIndex {
			self.nextButton.setTitle("DONE", for: .normal)
		}
		else {
			self.nextButton.setTitle("NEXT", for: .normal)
		}

		let indexPath = IndexPath(item: nextIndex, section: 0)
		collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
	}

	override func scrollViewWillEndDragging(_ scrollView: UIScrollView,
											withVelocity velocity: CGPoint,
											targetContentOffset: UnsafeMutablePointer<CGPoint>) {

		let x = targetContentOffset.pointee.x
		let pageID = x / view.frame.width
		pageControl.currentPage = Int(pageID)

		if pageControl.currentPage == 0 {
			self.previousButton.setTitle("", for: .normal)
		}
		else {
			self.previousButton.setTitle("PREV", for: .normal)
		}

		// change the text on the next button given the swipe action
		if pages.count - 1 == pageControl.currentPage {
			self.nextButton.setTitle("DONE", for: .normal)
		}
		else {
			self.nextButton.setTitle("NEXT", for: .normal)
		}

	}

	// MARK: Start

	override func viewDidLoad() {
		super.viewDidLoad()

		setupBottomControls()
		setupSkipButton()

		collectionView?.backgroundColor = UIColor(red: 27/255, green: 41/255, blue: 51/255, alpha: 1)
		// prevent NSInternalInconsistencyException & register cells
		collectionView?.register(OnboardingCell.self, forCellWithReuseIdentifier: "cellId")

		// allows for snaps between the cells
		collectionView?.isPagingEnabled = true
		collectionView?.showsHorizontalScrollIndicator = false
	}

	//using FilePrivate because the init of the button is private
	fileprivate func setupBottomControls() {

		let bottomControlsStackView = UIStackView(arrangedSubviews:
			[previousButton, pageControl, nextButton])

		// Tells the stack view to split
		bottomControlsStackView.distribution = .fillEqually
		view.addSubview(bottomControlsStackView)

		bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor), // safe for landscape
			bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
		])

		// Add targets after constraints are set up
		previousButton.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
		nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
	}

	fileprivate func setupSkipButton() {
		view.addSubview(skipButton)

		NSLayoutConstraint.activate([
			skipButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
			skipButton.widthAnchor.constraint(equalToConstant: 40),
			skipButton.heightAnchor.constraint(equalToConstant: 25),
			skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
		])

		// Add target after constraints are set up
		skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
	}

	// MARK: Save in UserDefaults

	func saveForCompletingOnboarding() {

		// check first again to make sure
		let savedAlready = loadAndCheckOnboarding()

		if !savedAlready {

			Analytics.logEvent(AnalyticsEventTutorialComplete, parameters: [
				AnalyticsParameterItemID: "id-Onboarding",
				AnalyticsParameterItemName: "Onboarding-dismiss",
				AnalyticsParameterContentType: "cont"
			])

			let completedTask = "completed"

			UserDefaults.standard.set(completedTask, forKey: ApplicationVariables.OnboardingCacheKey)
			UserDefaults.standard.synchronize()

			self.dismiss(animated: true, completion: nil)
		}
		else {
			print("Already saved this operation, dismissing before saving a duplicate string.")
			self.dismiss(animated: true, completion: nil)
		}
	}

	func loadAndCheckOnboarding() -> Bool {

		if let loadedData = UserDefaults.standard.string(forKey: ApplicationVariables.OnboardingCacheKey) {
			onboardingString = loadedData

			if onboardingString == "completed" {
				return true
			}
		}
		return false

	}

}
