//
//  ReadJoelViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadJoelViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var joelView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joelView.delegate = self
        joelView.loadWebPage(url: "https://www.bible.com/bible/59/jol.1")
        self.setLoadingSpinner(spinner: loading)
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        loading.startAnimating()
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
        
    }
    
}
