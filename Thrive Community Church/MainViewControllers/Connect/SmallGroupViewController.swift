//
//  SmallGroupViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/24/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class SmallGroupViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var smallGroup: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        smallGroup.delegate = self
        smallGroup.loadWebPage(url: "http://thrive-fl.org/join-small-group")
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
