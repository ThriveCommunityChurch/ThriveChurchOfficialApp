//
//  ReadJudgesViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 7/30/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadJudgesViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var judgesView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        judgesView.delegate = self
        judgesView.loadWebPage(url: "https://www.bible.com/bible/59/jdg.1")
        self.setLoadingSpinner(spinner: loading)
    }
	
    func webViewDidStartLoad(_ webView: UIWebView) {
        loading.startAnimating()
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
        
    }
    
}
