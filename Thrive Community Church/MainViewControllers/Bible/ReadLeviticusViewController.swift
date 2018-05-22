//
//  ReadLeviticusViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 7/16/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadLeviticusViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var leviticusView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leviticusView.delegate = self
		leviticusView.loadWebPage(url: "https://www.bible.com/bible/59/lev.1")
        self.setLoadingSpinner(spinner: loading)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loading.startAnimating()
		
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
        
    }
    
}
