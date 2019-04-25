//
//  ViewControllerExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 5/17/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

extension UIViewController {
	
	func setLoadingSpinner(spinner: UIActivityIndicatorView) {
		
		spinner.layer.cornerRadius = 4
		spinner.activityIndicatorViewStyle = .whiteLarge
		spinner.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255,
										  alpha: 0.75)
		spinner.color = .white
	}
	
	func displayAlertForAction() {
		let alert = UIAlertController(title: "Error",
									  message: "Unable to perform selected action",
									  preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		
		alert.addAction(okAction)
		present(alert, animated: true, completion: nil)
	}
	
	/// present a notmal alert with some specific message
	func presentBasicAlertWOTitle(message: String) {
		let alert = UIAlertController(title: "",
									  message: "\(message)",
			preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		
		alert.addAction(okAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	/// present a normal alert with some specific message & title
	func presentBasicAlertWTitle(title: String, message: String) {
		let alert = UIAlertController(title: "\(title)",
			message: "\(message)",
			preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		
		alert.addAction(okAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	/// Still opens the url
	func openUrlAnyways(link: String) {
		guard let url = URL(string: link) else { return }
		
		if UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
		else {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}
	
	func openUrlWithError(link: String) {
		guard let url = URL(string: link) else { return }
		
		if UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
		else {
			self.displayAlertForAction()
		}
	}
	
	func openVCAtSpecificURL(link: String) {
		
		let vc = OpenBiblePassageViewController()
		let passage = BiblePassage(url: link)
		vc.link = passage.url
		
		navigationController?.show(vc, sender: self)
	}
	
	func retrieveDownloadFromStorage(sermonMessageID: String) -> SermonMessage? {
		
		var sermonMessage: SermonMessage?
		
		if let _ = UserDefaults.standard.array(forKey: ApplicationVariables.DownloadedMessages) as? [String] {
			
			// now for each of these we need to go to UD and grab the physical objects,
			// shouldn't take long since UD lookups are O(1)
			
			// objects are stored in UD as Data objects
			let decoded = UserDefaults.standard.object(forKey: sermonMessageID) as? Data
			
			if decoded != nil {
				
				// reading from the messageId collection in UD
				let decodedSermonMessage = NSKeyedUnarchiver.unarchiveObject(with: decoded ?? Data()) as! SermonMessage
				
				sermonMessage = decodedSermonMessage
			}
		}
		
		return sermonMessage
	}
	
}
