//
//  FGCUSiteViewController.swift
//  Thrive Church Official App
//
//  Created by Thrive on 9/9/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit
import WebKit

class FGCUSiteViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var loading: UIActivityIndicatorView!
	
	let FGCUWebView: WKWebView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
    
		FGCUWebView.uiDelegate = self
		FGCUWebView.navigationDelegate = self
		
		view.insertSubview(FGCUWebView, at: 0)
		NSLayoutConstraint.activate([
			FGCUWebView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			FGCUWebView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			FGCUWebView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			FGCUWebView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
		
		let url = URL(string: "http://thrive-fl.org/youth/college/")!
		let request = URLRequest(url: url)
		FGCUWebView.load(request)
		
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
