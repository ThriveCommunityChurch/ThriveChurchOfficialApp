//
//  MeetTheTeamViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 7/6/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import WebKit
import UIKit

class MeetTheTeamViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    let teamView: WKWebView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamView.uiDelegate = self
		teamView.navigationDelegate = self
		
		view.insertSubview(teamView, at: 0)
		NSLayoutConstraint.activate([
			teamView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			teamView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			teamView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			teamView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
		
		let data = UserDefaults.standard.object(forKey: ConfigKeys.shared.Team) as? Data
		
		var teamLink = "http://thrive-fl.org/team/"
		
		if data != nil {
			
			// reading from the messageId collection in UD
			let decoded = NSKeyedUnarchiver.unarchiveObject(with: data!) as! ConfigSetting
			
			teamLink = "\(decoded.Value ?? "http://thrive-fl.org/team/")"
		}
		
		let encodedURL = teamLink.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

		let url = URL(string: encodedURL)!
		let request = URLRequest(url: url)
		teamView.load(request)
		
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
