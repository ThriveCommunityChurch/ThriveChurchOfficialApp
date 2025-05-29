//
//  ListenCollectionViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/19/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import MessageUI
import UIKit

private let reuseIdentifier = "Cell"

class ListenCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,
MFMailComposeViewControllerDelegate {

	var recentlyPlayedButton: UIBarButtonItem!
	var nowPlayingButton: UIBarButtonItem!
	var sermonSeries = [SermonSeriesSummary]()
	var apiDomain = "nil"
	var apiUrl: String = "nil"
    var loading: Bool = false
	var internetConnectionStatus: Network.Status = .unreachable
	var playedMessage: Bool = false
	private var alreadySelected: Bool = false
	var seriesMapping = [String: SermonSeries]()

	// Loading View
	var footerView: CustomFooterView?
	var isLoading: Bool = false
	let footerViewReuseIdentifier = "RefreshKey"
	var pageNumber: Int = 1
	var totalPages: Int = 1
	var overrideFooter: Bool = false

	// Improved Pagination
	var isPreloading: Bool = false
	private let preloadThreshold: CGFloat = 0.8 // Load next page when 80% scrolled
	private var lastContentOffset: CGFloat = 0
	private var scrollDirection: ScrollDirection = .down

	private enum ScrollDirection {
		case up, down
	}

	// API Connectivity issues
	var retryCounter: Int = 0
	var miscApiErrorText: String?
	var retryLimited: Bool = false

	let apiErrorMessage: UILabel = {
		let label = UILabel()
		label.text = "An error ocurred while loading the content.\n\n" +
		"Check your internet connection and try again. If the issue persists send " +
		"us an email."
		label.font = UIFont(name: "Avenir-Medium", size: 16)
		label.textColor = .lightGray
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 7
		return label
	}()

	let backgroundView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.bgDarkBlue
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	let retryButton: UIButton = {
		let button = UIButton()
		button.setTitle("Retry?", for: .normal)
		button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 16)
		button.setTitleColor(UIColor.mainBlue, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = .clear
        button.addTarget(ListenCollectionViewController.self, action: #selector(retryPageLoad), for: .touchUpInside)
		return button
	}()

	let spinner: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
        indicator.style = .large
		indicator.color = .white
		indicator.backgroundColor = .clear
		indicator.translatesAutoresizingMaskIntoConstraints = false
		return indicator
	}()

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()

		// in here we can clear some of the cache objects in order to save some system RSS
		self.seriesMapping = [String: SermonSeries]()
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		setupNavigationBar()
		setupCollectionView()
		self.presentOnboarding()

		// Ensure view background matches collection view to prevent white bars
		view.backgroundColor = UIColor.almostBlack

		collectionView?.dataSource = self
		collectionView?.delegate = self
		// Note: recentlyPlayedButton.isEnabled will be set in retrieveRecentlyPlayed()

        // Register cell classes
		collectionView?.register(SermonsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		collectionView?.register(CustomFooterView.self,
								 forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
									   withReuseIdentifier: footerViewReuseIdentifier)

		// contact the API on the address we have cached
		if let loadedData = UserDefaults.standard.string(forKey: ApplicationVariables.ApiCacheKey) {

			apiDomain = loadedData
			apiUrl = "http://\(apiDomain)/"
		}

        // call the API and determine how many of them there are
		checkConnectivity()

		// assuming there is an internet connection, do the things
		if internetConnectionStatus != .unreachable {
			setupViews()
			loading = true
			self.fetchAllSermons(isReset: false)

			// in the event that this user is on a very slow network, this will help display a message on the UI
			// so 2 minutes after this, check to see if we are still waiting for a response
			DispatchQueue.main.asyncAfter(wallDeadline: .now() + 60, execute: {

				if self.isLoading && self.sermonSeries.isEmpty {
					self.enableErrorViews(status: Network.Status.wifi)
				}

				self.isLoading = false
			})
		}
		else {
			setupViews()
			self.enableErrorViews(status: self.internetConnectionStatus)
		}
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		DispatchQueue.main.async {
			self.retrieveRecentlyPlayed()
		}

		self.alreadySelected = false

		refreshView()

		// Add an observer to keep track of this view while the app is in the background.
		// Call the func to refresh it when we enter the foreground again, see issue #
		NotificationCenter.default.addObserver(self,
											   selector: #selector(refreshView),
											   name: NSNotification.Name.NSExtensionHostWillEnterForeground,
											   object: UIApplication.shared)

		// Add observer for orientation changes to refresh layout
		NotificationCenter.default.addObserver(self,
											   selector: #selector(orientationDidChange),
											   name: UIDevice.orientationDidChangeNotification,
											   object: nil)
	}

	@objc private func orientationDidChange() {
		// Invalidate layout to recalculate cell sizes for new orientation
		DispatchQueue.main.async {
			self.collectionView?.collectionViewLayout.invalidateLayout()
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		// remove the observer we set in viewWillAppear() so we avoid mem leaks
		NotificationCenter.default.removeObserver(self)
	}

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sermonSeries.count
    }

	// MARK: - Collection View Delegate

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SermonsCollectionViewCell

		// configure the cell
		let selectedSeries = sermonSeries[indexPath.row]

		if let imageFromCache = ImageCache.sharedInstance.getImagesForKey(rssUrl: selectedSeries.ArtUrl) {
			// Image is cached, display immediately without any loading state
			cell.seriesArt.image = imageFromCache
			cell.hideLoadingState()
		}
		else {
			// Show loading state while image loads from network
			cell.showLoadingState()

			// Load image from network
			cell.loadImageWithCompletion(resourceUrl: selectedSeries.ArtUrl) { [weak cell] success in
				DispatchQueue.main.async {
					// Hide loading state immediately when image loading completes
					cell?.hideLoadingState()
				}
			}
		}

		// Check if we need to preload next page (improved pagination)
		checkForPreload(at: indexPath)

        return cell
    }

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		// Get section insets from flow layout
		let sectionInsets: UIEdgeInsets
		if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
			sectionInsets = flowLayout.sectionInset
		} else {
			sectionInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
		}

		// Account for section insets and inter-item spacing
		let horizontalInsets = sectionInsets.left + sectionInsets.right
		let verticalSpacing: CGFloat = 8 // 4pt top + 4pt bottom for card spacing
		let interItemSpacing: CGFloat = 16 // Space between columns on iPad

		let availableWidth = view.frame.width - horizontalInsets

		// Determine number of columns based on device and orientation
		let numberOfColumns = getNumberOfColumns()

		// Calculate card width accounting for inter-item spacing
		let totalInterItemSpacing = CGFloat(numberOfColumns - 1) * interItemSpacing
		let cardWidth = (availableWidth - totalInterItemSpacing) / CGFloat(numberOfColumns)

		// Apply maximum width constraint for readability
		let maxCardWidth: CGFloat = 600
		let finalCardWidth = min(cardWidth, maxCardWidth)
		let cardHeight = (finalCardWidth * (9.0 / 16.0)) + verticalSpacing // 16:9 ratio + spacing

		return CGSize(width: finalCardWidth, height: cardHeight)
	}

	private func getNumberOfColumns() -> Int {
		// iPhone: Always 1 column
		if UIDevice.current.userInterfaceIdiom == .phone {
			return 1
		}

		// iPad: Adaptive based on orientation and screen size
		if UIDevice.current.userInterfaceIdiom == .pad {
			let screenWidth = view.frame.width

			// Portrait: Always 2 columns for all iPad models
			if view.frame.height > view.frame.width {
				return 2
			}
			// Landscape: 2-3 columns based on screen width
			else {
				// iPad Pro 12.9" in landscape: 3 columns (width > 1200)
				if screenWidth > 1200 {
					return 3
				}
				// iPad Air and smaller iPads in landscape: 2 columns
				else {
					return 2
				}
			}
		}

		return 1 // Default fallback
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 8 // Vertical spacing between rows
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return getNumberOfColumns() > 1 ? 16 : 0 // Horizontal spacing between columns on iPad
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		// block segue of user interaction from popping more than once at a time
		if !self.alreadySelected {

			// update the mutex for this API request
			self.alreadySelected = true

			let selectedSeries = sermonSeries[indexPath.row]

			if let imageFromCache = ImageCache.sharedInstance.getImagesForKey(rssUrl: selectedSeries.ArtUrl) {

				// if we haven't already gotten thid data from the API, go get it
				// otherwise grab it from our cache
				let series = seriesMapping[selectedSeries.Id]

				// if this series is the current one, we still want to be able to make requests
				// for updates on this series, as changes may occur while a user is using the app
				if series == nil || series?.EndDate == nil {

					// load the sermon info from the API and transition when the GET is complete
					self.getSermonsForId(seriesId: selectedSeries.Id, image: imageFromCache)
				}
				else {
					// we can force unwrap this here because we checked above that it's not nil
					self.segueToSeriesDetailView(series: series!, image: imageFromCache)
				}
			}
		}
	}

	// MARK: - Collection View Pagination

	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

		if kind == UICollectionView.elementKindSectionFooter {

			let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
																			  withReuseIdentifier: footerViewReuseIdentifier,
																			  for: indexPath) as! CustomFooterView
			self.footerView = aFooterView
			self.footerView?.backgroundColor = UIColor.clear
			return aFooterView
		}
		else {
			let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
																			 withReuseIdentifier: footerViewReuseIdentifier,
																			 for: indexPath)
			return headerView
		}
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize.zero
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {

		if isLoading || overrideFooter {
			return CGSize.zero
		}

		return CGSize(width: collectionView.bounds.size.width, height: 35)
	}

	override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView
								view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {

		if elementKind == UICollectionView.elementKindSectionFooter {
			self.footerView?.prepareInitialAnimation()
		}
	}

	override func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView
								view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {

		if elementKind == UICollectionView.elementKindSectionFooter {
			self.footerView?.stopAnimate()
		}
	}

	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		// Track scroll direction
		let currentOffset = scrollView.contentOffset.y
		scrollDirection = currentOffset > lastContentOffset ? .down : .up
		lastContentOffset = currentOffset

		// Check for predictive loading when scrolling down
		if scrollDirection == .down {
			checkForPredictiveLoading(scrollView: scrollView)
		}
	}

	// MARK: - Improved Pagination Methods

	private func checkForPreload(at indexPath: IndexPath) {
		// Check if we're approaching the end of current content
		let totalItems = sermonSeries.count
		let threshold = Int(Double(totalItems) * preloadThreshold)

		if indexPath.row >= threshold && !isPreloading && pageNumber < totalPages {
			triggerPreload()
		}
	}

	private func checkForPredictiveLoading(scrollView: UIScrollView) {
		let contentHeight = scrollView.contentSize.height
		let scrollViewHeight = scrollView.frame.height
		let scrollOffset = scrollView.contentOffset.y

		// Calculate how much of the content has been scrolled
		let scrollPercentage = scrollOffset / (contentHeight - scrollViewHeight)

		// Trigger preload when user has scrolled 80% of the content
		if scrollPercentage >= preloadThreshold && !isPreloading && pageNumber < totalPages {
			triggerPreload()
		}
	}

	private func triggerPreload() {
		guard !isPreloading && !isLoading && pageNumber < totalPages else { return }

		print("Triggering predictive load for page \(pageNumber + 1)")
		isPreloading = true
		pageNumber += 1

		// Show subtle loading indicator in footer
		footerView?.startAnimate()

		fetchAllSermons(isReset: false)
	}

	// MARK: - Methods
	func openLive(_ sender: Any) {

		let data = UserDefaults.standard.object(forKey: ConfigKeys.shared.Live) as? Data

		var liveLink = "https://facebook.com/thriveFl/"

		if data != nil {

			// reading from the messageId collection in UD
            var decoded: ConfigSetting? = nil

            do {
                decoded = try NSKeyedUnarchiver.unarchivedObject(ofClass: ConfigSetting.self, from: data!)
            }
            catch {

            }

			liveLink = "\(decoded?.Value ?? "https://facebook.com/thriveFl/")"
		}

		let fbData = UserDefaults.standard.object(forKey: ConfigKeys.shared.FBPageID) as? Data

		var fbId = "157139164480128"

		if fbData != nil {

			// reading from the messageId collection in UD
            var decoded: ConfigSetting? = nil

            do {
                decoded = try NSKeyedUnarchiver.unarchivedObject(ofClass: ConfigSetting.self, from: fbData!)
            }
            catch {

            }

			fbId = "\(decoded?.Value ?? "157139164480128")"
		}

		let encodedURL = liveLink.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

		let url = URL(string: encodedURL)!
		let appURL = URL(string: "fb://profile/\(fbId)")!

		// Go to the page in FB and hopefully they see we are streaming
		if UIApplication.shared.canOpenURL(appURL) {
			UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
		}
		else {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}

	func setupViews() {
		view.addSubview(backgroundView)
		view.addSubview(apiErrorMessage)
		view.addSubview(retryButton)
		view.addSubview(spinner)

		NSLayoutConstraint.activate([
			apiErrorMessage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			apiErrorMessage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			apiErrorMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),
			retryButton.leadingAnchor.constraint(equalTo: apiErrorMessage.leadingAnchor, constant: 64),
			retryButton.trailingAnchor.constraint(equalTo: apiErrorMessage.trailingAnchor, constant: -64),
			retryButton.topAnchor.constraint(equalTo: apiErrorMessage.bottomAnchor, constant: 16),
			spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			spinner.heightAnchor.constraint(equalToConstant: 37),
			spinner.widthAnchor.constraint(equalToConstant: 37)

		])

		// set backgroundView frame to self
		self.backgroundView.frame = view.frame

		self.resetErrorViews()
	}

	@objc func retryPageLoad() {

		retryCounter = retryCounter + 1
		checkConnectivity()

		if internetConnectionStatus != .unreachable {

			if retryCounter >= 3 {
				// don't let anyone retry more than a few times because it looks like nothing is changing
				// if a user is still having issues then the API is probably down
				// or they are not online

				self.resetErrorViews()

				retryLimited = true
				fetchAllSermons(isReset: true)
			}
			else {

				self.resetErrorViews()

				// call the API and determine how many of them there are
				self.fetchAllSermons(isReset: true)
			}
		}
		else {
			self.enableErrorViews(status: self.internetConnectionStatus)
		}
	}

	// MARK: - Setup Views
	func setupCollectionView() {
		collectionView.backgroundColor = UIColor.almostBlack

		// Ensure collection view extends to bottom edge without white bar (iOS 15+ minimum deployment target)
		collectionView.contentInsetAdjustmentBehavior = .automatic

		// Ensure collection view fills entire view
		extendedLayoutIncludesOpaqueBars = true
		edgesForExtendedLayout = .all

		// Configure flow layout for multi-column support
		if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			flowLayout.scrollDirection = .vertical
			flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
		}
	}

	// MARK: - Setup Navigation Bar
	func setupNavigationBar() {
		title = "Listen"
		let recentlyPlayedImage = UIImage(named: "RecentlyPlayed")
		recentlyPlayedButton = UIBarButtonItem(image: recentlyPlayedImage, style: .plain, target: self, action: #selector(openRecentlyPlayed))
		recentlyPlayedButton?.tintColor = UIColor.white

		// Add Now Playing button - always visible so users can access downloaded content
		let nowPlayingImage = UIImage(named: "playback") // Using Playback icon for now playing
		nowPlayingButton = UIBarButtonItem(image: nowPlayingImage, style: .plain, target: self, action: #selector(openNowPlaying))
		nowPlayingButton?.tintColor = UIColor.white

		// Set both buttons in navigation bar - Now Playing button is always visible
		navigationItem.rightBarButtonItems = [recentlyPlayedButton!, nowPlayingButton!]
	}

	@objc func openRecentlyPlayed() {
		let recentlyPlayedVC = RecentlyPlayedViewController()
		navigationController?.pushViewController(recentlyPlayedVC, animated: true)
	}

	@objc func openNowPlaying() {
		let nowPlayingVC = NowPlayingViewController()
		navigationController?.pushViewController(nowPlayingVC, animated: true)
	}



}
