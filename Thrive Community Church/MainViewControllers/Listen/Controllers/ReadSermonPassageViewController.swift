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
		view.isSelectable = false
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let spinner: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		indicator.style = .whiteLarge
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
			
			// something went wrong here
			if error != nil {
				print(error!)
				
				return
			}
			
			do {
				
				let passageResponse = try JSONDecoder().decode(SermonPassageResponse.self,
															 from: data!)
				
				DispatchQueue.main.async {
					
					let str = String(utf8String: passageResponse.Passage.cString(using: String.Encoding.utf8)!) ?? ""
					
					// make a reusable dict
					var attrs: [NSAttributedString.Key: Any] =
						[
							NSAttributedString.Key.foregroundColor: UIColor.white,
							NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 16) as Any
						]
					
					let attStr = NSMutableAttributedString(string: passageResponse.Passage, attributes: attrs)
					
					var index: Int = 0
					for i in str {
						
						// this is all a bit magic string-y but it works about as well as you'd expect
						if  i == "\u{00b3}" ||
							i == "\u{00b2}"
						{
							// add the new attribute to the dict
							attrs[NSAttributedString.Key.baselineOffset] = 2
							attrs[NSAttributedString.Key.font] = UIFont(name: "Avenir-Medium", size: 13.6)
							
							attStr.setAttributes(attrs, range: NSRange(location: index, length: 1))
						}
						else if i == "\u{00b9}" {
							
							// add the new attribute to the dict
							attrs[NSAttributedString.Key.baselineOffset] = 2.25
							attrs[NSAttributedString.Key.font] = UIFont(name: "Avenir-Medium", size: 13)
							
							attStr.setAttributes(attrs, range: NSRange(location: index, length: 1))
						}
						
						index = index + 1
					}
					self.passageTextArea.attributedText = attStr
					self.spinner.stopAnimating()
				}
			}
			catch let jsonError {
				print(jsonError)
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
	
}
