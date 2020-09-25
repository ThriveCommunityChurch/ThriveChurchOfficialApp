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
		spinner.style = .whiteLarge
		spinner.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255,
										  alpha: 0.75)
		spinner.color = .white
	}
	
	func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
		let size = image.size

		let widthRatio  = targetSize.width  / size.width
		let heightRatio = targetSize.height / size.height

		// Figure out what our orientation is, and use that to form the rectangle
		var newSize: CGSize
		if(widthRatio > heightRatio) {
			newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
		} else {
			newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
		}

		// This is the rect that we've calculated out and this is what is actually used below
		let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

		// Actually do the resizing to the rect using the ImageContext stuff
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		image.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return newImage
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
