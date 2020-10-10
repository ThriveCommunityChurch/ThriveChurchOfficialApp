//
//  GenericSiteViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/29/20.
//  Copyright © 2020 Thrive Community Church. All rights reserved.
//

import WebKit
import UIKit

class GenericSiteViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

	let websiteView: WKWebView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	var loading: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	var link: String = "https://google.com/"
	
	public var site: String = "https://google.com/" {
		didSet {
			self.link = site.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
		}
	}
	
	public var navHeader: String = "Website" {
		didSet {
			// Setting the title of the view before we hit viewDidLoad
			navigationItem.title = navHeader
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		websiteView.uiDelegate = self
		websiteView.navigationDelegate = self
		
		view.addSubview(websiteView)
		view.addSubview(loading)
		
		NSLayoutConstraint.activate([
			websiteView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			websiteView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			websiteView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			websiteView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])

		let url = URL(string: link)!
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
