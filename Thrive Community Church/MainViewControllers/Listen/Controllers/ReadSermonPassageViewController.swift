//
//  ReadSermonPassageViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 2/5/19.
//  Copyright © 2019 Thrive Community Church. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


class ReadSermonPassageViewController: UIViewController {
	
	// MARK: - Vars
	public var Passage = String() {
		didSet {
			self.passageToSearch = Passage
			
			// Setting the title of the view before we hit viewDidLoad
			navigationItem.title = Passage
		}
	}
	
	public var API = String() {
		didSet {
			// set the API url before we load
			self.apiUrl = API
		}
	}
	
	private var passageToSearch: String = ""
	private var apiUrl: String = ""
	private var esvApiKey: String = ""
	
	// This time, we'll declare avPlayer as an instance variable,
	// which means it exists as long as our view controller exists.
	var player: AVPlayer!
	
	// MARK: - UI Elements
	let passageTextArea: UITextView = {
		let view = UITextView()
		view.backgroundColor = UIColor.bgDarkBlue
		view.font = UIFont(name: "Avenir-Medium", size: 16)
		view.textColor = .white
		view.isUserInteractionEnabled = true
		view.indicatorStyle = .white
		view.isEditable = false
		view.isSelectable = true
		view.translatesAutoresizingMaskIntoConstraints = false

		// Enhanced text view configuration for better readability
		view.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
		view.showsVerticalScrollIndicator = true
		view.alwaysBounceVertical = true

		return view
	}()
	
	let spinner: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
        indicator.style = UIActivityIndicatorView.Style.large
		indicator.color = .white
		indicator.backgroundColor = .clear
		indicator.translatesAutoresizingMaskIntoConstraints = false
		return indicator
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		loadPassageFromESV(searchText: self.passageToSearch)
		
		// grab the API key for the ESV API from the config file
		if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
			let nsDictionary = NSDictionary(contentsOfFile: path)
			
			self.esvApiKey = nsDictionary?[ApplicationVariables.ESVApiCacheKey] as? String ?? ""
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	
	func setupViews() {
		view.addSubview(passageTextArea)
		view.addSubview(spinner)
		
		var image = UIImage(named: "Listen")
		image = resizeImage(image: image!, targetSize: CGSize(width: 25, height: 25))!
		let listenAudioButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(loadAudioFromESV))
		listenAudioButton.tintColor = UIColor.white
		
		self.navigationItem.rightBarButtonItem = listenAudioButton

				
		// Constraints
		NSLayoutConstraint.activate([
			passageTextArea.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			passageTextArea.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			passageTextArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			passageTextArea.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
		
		self.spinner.startAnimating()
	}
	
	// MARK: - Methods
	
	func loadPassageFromESV(searchText: String) {
		
		var encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
		encodedSearchText = encodedSearchText?.replacingOccurrences(of: ":", with: "%3A")
		
		// for some reason this method of all the others wants this to be explicitly defined
		let queryString = "http://\(apiUrl)/api/passages?searchCriteria=\(encodedSearchText ?? "")"
		let url = URL(string: queryString)
		URLSession.shared.dataTask(with: url!) { (data, response, error) in
			
			// Enhanced error handling
			if let error = error {
				print("Error loading passage: \(error.localizedDescription)")
				DispatchQueue.main.async {
					self.handleLoadingError(error)
				}
				return
			}
			
			do {
				
				let passageResponse = try JSONDecoder().decode(SermonPassageResponse.self,
															 from: data!)
				
				DispatchQueue.main.async {
					// Use new BibleTextFormatter for proper text rendering
					let formattedText = BibleTextFormatter.formatBibleText(passageResponse.Passage)
					self.passageTextArea.attributedText = formattedText
					self.spinner.stopAnimating()
				}
			}
			catch let jsonError {
				print("JSON parsing error: \(jsonError.localizedDescription)")
				DispatchQueue.main.async {
					self.handleLoadingError(jsonError)
				}
			}
		}.resume()
	}
	
	@objc func loadAudioFromESV() {
		
		// for some reason this method of all the others wants this to be explicitly defined
		let queryString = "https://api.esv.org/v3/passage/audio/?q=\(self.passageToSearch)"
		let encoded = queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
		
		guard let url = URL(string: encoded!) else { return }
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("Token \(esvApiKey)", forHTTPHeaderField: "Authorization")
		request.timeoutInterval = 60.0
				
		do {
			
			let headers: [String: String] = [
			   "Authorization": "Token \(esvApiKey)",
				"Content-Type": "application/json"
			]
			let asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
			let playerItem = AVPlayerItem(asset: asset)
			player = AVPlayer(playerItem: playerItem)
			player.automaticallyWaitsToMinimizeStalling = false
			player.isMuted = false
			player.rate = 1.0
			
			try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.allowBluetooth])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
			
			player.play()
			
		}
		catch let error {
			print(error)
		}
	}

	// MARK: - Error Handling

	private func handleLoadingError(_ error: Error) {
		spinner.stopAnimating()

		let errorMessage = "Unable to load Bible passage. Please check your connection and try again."
		passageTextArea.text = errorMessage
		passageTextArea.textColor = UIColor.lightGray

		print("Passage loading failed: \(error.localizedDescription)")
	}

}
