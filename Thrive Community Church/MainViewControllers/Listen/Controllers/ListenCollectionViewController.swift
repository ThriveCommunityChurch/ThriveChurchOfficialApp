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

	@IBOutlet weak var recentlyPlayedButton: UIBarButtonItem!
	@IBOutlet weak var livestreamButton: UIBarButtonItem!
	var sermonSeries = [SermonSeriesSummary]()
	var apiDomain = "nil"
	var apiUrl: String = "nil"
	var secondsRemaining: Double?
	var expireTime: Date?
	var timer = Timer()
	var pollingData: LivePollingResponse?
	var livestreamData: LivestreamingResponse?
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
		view.translatesAutoresizingMaskIntoConstraints = true
		return view
	}()
	
	let retryButton: UIButton = {
		let button = UIButton()
		button.setTitle("Retry?", for: .normal)
		button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 16)
		button.setTitleColor(UIColor.mainBlue, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = .clear
		button.addTarget(self, action: #selector(retryPageLoad), for: .touchUpInside)
		return button
	}()

	let spinner: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		indicator.activityIndicatorViewStyle = .whiteLarge
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
		
		self.presentOnboarding()
		
		collectionView?.dataSource = self
		collectionView?.delegate = self
		
		livestreamButton.isEnabled = false
		self.recentlyPlayedButton.isEnabled = false

        // Register cell classes
		collectionView?.register(SermonsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		collectionView?.register(UINib(nibName: "CustomFooterView", bundle: nil),
									   forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
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
			self.fetchAllSermons(isReset: false)
			self.fetchLiveStream()
			
		}
		else {
			setupViews()
			self.enableErrorViews(status: self.internetConnectionStatus)
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
		DispatchQueue.main.async {
			self.retrieveRecentlyPlayed()
		}
		
		self.alreadySelected = false
		
		refreshView()
		
		// Add an observer to keep track of this view while the app is in the background.
		// Call the func to refresh it when we enter the foreground again, see issue #
		NotificationCenter.default.addObserver(self,
											   selector: #selector(refreshView),
											   name: NSNotification.Name.UIApplicationWillEnterForeground,
											   object: UIApplication.shared)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillAppear(true)
		
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
			
			cell.seriesArt.image = imageFromCache
		}
		else {
			// get the image from the API and update the image cache by reference
			cell.seriesArt.loadImage(resourceUrl: selectedSeries.ArtUrl)
		}
		
        return cell
    }
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let width = view.frame.width
		let height = (width) * (9 / 16) // 16x9 ratio
		
		return CGSize(width: width, height: height)
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
		
		if kind == UICollectionElementKindSectionFooter {
			
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
		
		if elementKind == UICollectionElementKindSectionFooter {
			self.footerView?.prepareInitialAnimation()
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView
								view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
		
		if elementKind == UICollectionElementKindSectionFooter {
			self.footerView?.stopAnimate()
		}
	}
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		// compute the scroll value and play with the threshold to get desired effect
		let contentOffset = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		let diffHeight = contentHeight - contentOffset
		let frameHeight = scrollView.bounds.size.height
		var triggerThreshold = Float((diffHeight - frameHeight)) / Float(100.0)
		triggerThreshold = min(triggerThreshold, 0.0) / 2
		
		// we did some maths above to determine what force a user is pulling down with
		// set a threshold before the event triggers
		if fabs(triggerThreshold) <= 1.0 {
			
			let pullRatio  = min(fabs(triggerThreshold), 0.80)
			self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio * 1.2))
			if pullRatio >= 0.80 {
				self.footerView?.animateFinal()
			}
		}
	}
	
	override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		
		// assuming there are pages left, and we hit the threshold, when the view
		// finishes moving then we can load the things
		if self.pageNumber < self.totalPages {
			
			// this is called many times so we need to make sure that we aren't
			// doing the work more than we should
			if (self.footerView?.isAnimatingFinal)! && !self.isLoading {
				
				print("load more trigger")
				self.isLoading = true
				self.footerView?.startAnimate()
				
				// loading more from the API
				// use self.overrideFooter
				
				// TODO: Implement something that prevents a user from requesting a page beyond the max!
				self.pageNumber = self.pageNumber + 1
				fetchAllSermons(isReset: false)
			}
		}
	}
	
	// MARK: - Methods
	@IBAction func openLive(_ sender: Any) {
		let url = URL(string: "https://facebook.com/thriveFl/")!
		let appURL = URL(string: "fb://profile/157139164480128")!
		
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
		
		if #available(iOS 11.0, *) {
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
		}
		else {
			// Fallback on earlier versions
			NSLayoutConstraint.activate([
				apiErrorMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
				apiErrorMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
				apiErrorMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),
				retryButton.leadingAnchor.constraint(equalTo: apiErrorMessage.leadingAnchor, constant: 64),
				retryButton.trailingAnchor.constraint(equalTo: apiErrorMessage.trailingAnchor, constant: -64),
				retryButton.topAnchor.constraint(equalTo: apiErrorMessage.bottomAnchor, constant: 16),
				spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
				spinner.heightAnchor.constraint(equalToConstant: 37),
				spinner.widthAnchor.constraint(equalToConstant: 37)
			])
		}
		
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
				
				self.enableLoadingScreen()
				
				retryLimited = true
				fetchAllSermons(isReset: true)
			}
			else {
				
				self.enableLoadingScreen()
				
				// call the API and determine how many of them there are
				self.fetchAllSermons(isReset: true)
				self.fetchLiveStream()
			}
		}
		else {
			self.enableErrorViews(status: self.internetConnectionStatus)
		}
	}

}
