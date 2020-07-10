//
//  PrayerRequestsViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/20/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import WebKit
import UIKit

class PrayerRequestsViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
        
    let prayerRequestsView: WKWebView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prayerRequestsView.uiDelegate = self
		prayerRequestsView.navigationDelegate = self
		
		view.insertSubview(prayerRequestsView, at: 0)
		NSLayoutConstraint.activate([
			prayerRequestsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			prayerRequestsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			prayerRequestsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			prayerRequestsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
		
		//let data = UserDefaults.standard.object(forKey: ConfigKeys.shared.Prayer) as? Data
		
		let prayerLink = "http://thrive-fl.org/prayer-requests"
		
//		if data != nil {
//			
//			// reading from the messageId collection in UD
//			let decoded = NSKeyedUnarchiver.unarchiveObject(with: data!) as! ConfigSetting
//			
//			prayerLink = "\(decoded.Value ?? "http://thrive-fl.org/prayer-requests")"
//		}
		
		//let encodedURL = self.prayerLink.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

		let url = URL(string: prayerLink)!
		let request = URLRequest(url: url)
		prayerRequestsView.load(request)
		
        self.setLoadingSpinner(spinner: loading)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		loading.stopAnimating()
	}
	
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		loading.startAnimating()
	}
    
}
