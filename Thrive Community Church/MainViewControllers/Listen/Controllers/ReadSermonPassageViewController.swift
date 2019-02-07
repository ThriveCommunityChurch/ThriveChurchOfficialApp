//
//  ReadSermonPassageViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 2/5/19.
//  Copyright © 2019 Thrive Community Church. All rights reserved.
//

import UIKit


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
	
	// MARK: - UI Elements
	let passageTextArea: UITextView = {
		let view = UITextView()
		view.backgroundColor = UIColor.bgDarkBlue
		view.font = UIFont(name: "Avenir-Medium", size: 16)
		view.textColor = .white
		view.isUserInteractionEnabled = false
		view.indicatorStyle = .white
		view.isEditable = false
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		loadPassageFromESV(searchText: self.passageToSearch)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	
	func setupViews() {
		view.addSubview(passageTextArea)
		
		// Constraints
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				passageTextArea.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				passageTextArea.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				passageTextArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				passageTextArea.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
			])
		} else {
			NSLayoutConstraint.activate([
				passageTextArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				passageTextArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				passageTextArea.topAnchor.constraint(equalTo: view.topAnchor),
				passageTextArea.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			])
		}
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
				
				print(passageResponse)
				
				DispatchQueue.main.async {
					
					let str = String(utf8String: passageResponse.Passage.cString(using: String.Encoding.utf8)!)
					
					// make a reusable dict
					var attrs: [NSAttributedStringKey: Any] =
						[
							NSAttributedString.Key.foregroundColor: UIColor.white,
							NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 16) as Any
						]
					
					let attStr = NSMutableAttributedString(string: passageResponse.Passage, attributes: attrs)
				
					
					var index: Int = 0
					for i in str! {
						
						if  i == "\u{00b3}" ||
							i == "\u{00b2}"
						{
							// add the new attribute to the dict
							// this is a bit magic string-y but it works like you'd expect
							attrs[NSAttributedStringKey.baselineOffset] = 2
							attrs[NSAttributedStringKey.font] = UIFont(name: "Avenir-Medium", size: 13.6)
							
							attStr.setAttributes(attrs, range: NSRange(location: index, length: 1))
						}
						else if i == "\u{00b9}" {
							
							// add the new attribute to the dict
							// this is a bit magic string-y but it works like you'd expect
							attrs[NSAttributedStringKey.baselineOffset] = 2
							attrs[NSAttributedStringKey.font] = UIFont(name: "Avenir-Medium", size: 13.2)
							
							attStr.setAttributes(attrs, range: NSRange(location: index, length: 1))
						}
						
						index = index + 1
					}
					self.passageTextArea.attributedText = attStr
				}
			}
			catch let jsonError {
				print(jsonError)
			}
		}.resume()
	}
	
}
