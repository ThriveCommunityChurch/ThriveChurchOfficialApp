//
//  ReadEzekielViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadEzekielViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var ezekielView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ezekielView.delegate = self
        ezekielView.loadWebPage(url: "https://www.bible.com/bible/59/ezk.1")
        self.setLoadingSpinner(spinner: loading)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loading.startAnimating()

    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
        
    }
    
}
