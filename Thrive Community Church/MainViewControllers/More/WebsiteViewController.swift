//
//  MoreViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/3/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import WebKit
import UIKit

class WebsiteViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
	
    let websiteView: WKWebView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        websiteView.uiDelegate = self
		websiteView.navigationDelegate = self
		
		view.insertSubview(websiteView, at: 0)
		NSLayoutConstraint.activate([
			websiteView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			websiteView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			websiteView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			websiteView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
		
		let url = URL(string: "http://thrive-fl.org")!
		let request = URLRequest(url: url)
		websiteView.load(request)
		
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
