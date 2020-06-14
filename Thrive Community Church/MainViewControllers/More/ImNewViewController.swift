//
//  ImNewViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/16/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import WebKit
import UIKit

class ImNewViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    let imNew: WKWebView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        imNew.uiDelegate = self
		imNew.navigationDelegate = self
		
		view.insertSubview(imNew, at: 0)
		NSLayoutConstraint.activate([
			imNew.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			imNew.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			imNew.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			imNew.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
		
		let url = URL(string: "http://thrive-fl.org/im-new/")!
		let request = URLRequest(url: url)
		imNew.load(request)
		
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
