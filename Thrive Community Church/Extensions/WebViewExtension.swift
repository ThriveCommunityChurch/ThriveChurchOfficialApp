//
//  WebViewExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 5/22/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

extension UIWebView: UIWebViewDelegate {
	
	func loadWebPage(url: String) {
		
		guard let site = URL(string: url) else { return }
		let request = URLRequest(url: site)
		
		self.loadRequest(request)
	}
}
