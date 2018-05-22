//
//  ReadAmosViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadAmosViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var amosView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amosView.delegate = self
        amosView.loadWebPage(url: "https://www.bible.com/bible/59/amo.1")
        self.setLoadingSpinner(spinner: loading)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loading.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
        
    }
    
}
