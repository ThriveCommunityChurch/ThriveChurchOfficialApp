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
	
	func displayAlertForAction() {
		let alert = UIAlertController(title: "Error",
									  message: "Unable to perform selected action",
									  preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		
		alert.addAction(okAction)
		present(alert, animated: true, completion: nil)
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
	
}
