//
//  SmallGroupViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/24/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import WebKit
import UIKit

class SmallGroupViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    let smallGroup: WKWebView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        smallGroup.uiDelegate = self
		smallGroup.navigationDelegate = self
		
		view.insertSubview(smallGroup, at: 0)
		NSLayoutConstraint.activate([
			smallGroup.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			smallGroup.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			smallGroup.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			smallGroup.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
		
		let data = UserDefaults.standard.object(forKey: ConfigKeys.shared.SmallGroup) as? Data
		
		var groupsLink = "http://thrive-fl.org/join-small-group"
		
		if data != nil {
			
			// reading from the messageId collection in UD
            var decoded: ConfigSetting? = nil
            
            do {
                 decoded = try NSKeyedUnarchiver.unarchivedObject(ofClass: ConfigSetting.self, from: data!)
            }
            catch {
                
            }
            
			groupsLink = "\(decoded?.Value ?? "http://thrive-fl.org/join-small-group")"
		}
		
		let encodedURL = groupsLink.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

		let url = URL(string: encodedURL)!
		let request = URLRequest(url: url)
		smallGroup.load(request)
		
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
