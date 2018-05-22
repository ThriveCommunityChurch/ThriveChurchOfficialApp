//
//  FGCUNotificationsViewController.swift
//  Thrive Church Official App
//
//  Created by Thrive on 9/9/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class FGCUNotificationsViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var loadFGCUNotifWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFGCUNotifWebView.delegate = self
		loadFGCUNotifWebView.loadWebPage(url: "https://goo.gl/forms/mWauaAZjYahokv3a2")
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
