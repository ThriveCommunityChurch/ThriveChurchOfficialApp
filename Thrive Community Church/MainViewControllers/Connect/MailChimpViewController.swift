//
//  MailChimpViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/29/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import WebKit
import UIKit

class MailChimpViewCoontroller: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
	
	let webview: WKWebView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.uiDelegate = self
		webview.navigationDelegate = self
		
		view.insertSubview(webview, at: 0)
		
		NSLayoutConstraint.activate([
			webview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			webview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			webview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			webview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
		
		let url = URL(string: "http://thrive-fl.org/mailing-list/")!
		let request = URLRequest(url: url)
		webview.load(request)
		
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
