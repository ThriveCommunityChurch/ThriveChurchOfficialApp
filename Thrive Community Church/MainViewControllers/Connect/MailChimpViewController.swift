//
//  MailChimpViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/29/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class MailChimpViewCoontroller: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var Webview: UIWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Webview.delegate = self
        Webview.loadWebPage(url: "http://thrive-fl.org/mailing-list/")
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
