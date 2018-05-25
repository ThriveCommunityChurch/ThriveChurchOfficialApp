//
//  ReadHebrewsViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/2/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadHebrewsViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var hebrewsView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hebrewsView.delegate = self
        hebrewsView.loadWebPage(url: "https://www.bible.com/bible/59/heb.1")
        self.setLoadingSpinner(spinner: loading)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loading.startAnimating()
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
        
    }
    
}
