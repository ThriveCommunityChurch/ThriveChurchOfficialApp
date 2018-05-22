//
//  ReadExodusViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 7/14/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadExodusViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var exodusView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exodusView.delegate = self
        exodusView.loadWebPage(url: "https://www.bible.com/bible/59/exo.1")
        self.setLoadingSpinner(spinner: loading)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loading.startAnimating()
		
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
        
    }
    
}
