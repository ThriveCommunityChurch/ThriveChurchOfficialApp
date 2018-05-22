//
//  ReadGenesisViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 7/11/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadGenesisViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var genesisView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genesisView.delegate = self
        genesisView.loadWebPage(url: "https://www.bible.com/bible/59/gen.1")
        self.setLoadingSpinner(spinner: loading)
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        loading.startAnimating()
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
        
    }
    
}
