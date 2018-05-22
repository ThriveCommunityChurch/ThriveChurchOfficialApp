//
//  MoreViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/3/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class WebsiteViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var websiteView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        websiteView.delegate = self
        websiteView.loadWebPage(url: "http://thrive-fl.org")
        self.setLoadingSpinner(spinner: loading)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
		
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loading.startAnimating()
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
        
    }
    
}
