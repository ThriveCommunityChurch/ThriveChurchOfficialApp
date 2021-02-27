//
//  RSSViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 2/24/21.
//  Copyright © 2021 Thrive Community Church. All rights reserved.
//

import UIKit
import WebKit

class RSSViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

	let WebView: WKWebView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let supportedSchemes = ["http", "https"]
	
	private var html = ""
	
	public var Html: String = "" {
		didSet {
			html = Html
		}
	}
	
	public var NavHeader: String = "" {
		didSet {
			navigationItem.title = NavHeader
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		WebView.uiDelegate = self
		WebView.navigationDelegate = self
		
		view.insertSubview(WebView, at: 0)
		NSLayoutConstraint.activate([
			WebView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			WebView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			WebView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			WebView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
		
		WebView.loadHTMLString(html, baseURL: nil)
    }
    
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
			defer {
				decisionHandler(.allow)
			}

			guard
				navigationAction.navigationType == .linkActivated,
				let url = navigationAction.request.url,
				let scheme = url.scheme,
				supportedSchemes.contains(scheme)
			else {
				return
			}

			openUrlAnyways(link: "\(url)")
		}

}
