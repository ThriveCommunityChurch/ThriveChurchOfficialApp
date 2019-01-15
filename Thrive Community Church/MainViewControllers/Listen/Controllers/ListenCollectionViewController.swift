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
	
	// API Connectivity issues
	var retryCounter: Int = 0
	var miscApiErrorText: String?
	var retryLimited: Bool = false
	
	let apiErrorMessage: UILabel = {
		let label = UILabel()
		label.text = "An error ocurred while loading the content.\n\n" +
		"Check your internet connection and try again. If the issue persists send " +
		"us an email at \nwyatt@thrive-fl.org."
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
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
		
		collectionView?.dataSource = self
		collectionView?.delegate = self
		
		livestreamButton.isEnabled = false

        // Register cell classes
		collectionView?.register(SermonsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		
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

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sermonSeries.count
    }
	
	// MARk: - Collection View Delegate

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
		
		let selectedSeries = sermonSeries[indexPath.row]
		
		if let imageFromCache = ImageCache.sharedInstance.getImagesForKey(rssUrl: selectedSeries.ArtUrl) {
			
			// load the sermon info from the API and transition when the GET is complete
			getSermonsForId(seriesId: selectedSeries.Id, image: imageFromCache)
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
		
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				apiErrorMessage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
				apiErrorMessage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
				apiErrorMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),
				retryButton.leadingAnchor.constraint(equalTo: apiErrorMessage.leadingAnchor, constant: 64),
				retryButton.trailingAnchor.constraint(equalTo: apiErrorMessage.trailingAnchor, constant: -64),
				retryButton.topAnchor.constraint(equalTo: apiErrorMessage.bottomAnchor, constant: 16)
				
			])
		}
		else {
			// Fallback on earlier versions
			NSLayoutConstraint.activate([
				apiErrorMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
				apiErrorMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
				apiErrorMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
			if retryCounter >= 5 {
				// don't let anyone retry more than a few times because it looks like nothing is changing
				// if a user is still having issues then the API is probably down
				// or they are not online
				
				retryLimited = true
				fetchAllSermons(isReset: true)
			}
			else {
				
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
