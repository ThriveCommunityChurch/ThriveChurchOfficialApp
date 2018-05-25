//
//  ReadNumbersViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 7/16/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadNumbersViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var numbersView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numbersView.delegate = self
        numbersView.loadWebPage(url: "https://www.bible.com/bible/59/num.1")
        self.setLoadingSpinner(spinner: loading)
    }
	
    func webViewDidStartLoad(_ webView: UIWebView) {
        loading.startAnimating()
		
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
        
    }
    
}
