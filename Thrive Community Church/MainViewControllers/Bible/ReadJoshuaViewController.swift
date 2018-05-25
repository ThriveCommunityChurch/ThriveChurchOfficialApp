//
//  ReadJoshuaViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 7/17/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadJoshuaViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var joshuaView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joshuaView.delegate = self
        joshuaView.loadWebPage(url: "https://www.bible.com/bible/59/jos.1")
        self.setLoadingSpinner(spinner: loading)
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        loading.startAnimating()
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
        
    }
    
}
