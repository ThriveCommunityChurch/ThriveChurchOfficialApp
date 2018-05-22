//
//  FGCUEventsViewController.swift
//  Thrive Church Official App
//
//  Created by Thrive on 9/9/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class FGCUEventsViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var FGCUEventsWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        FGCUEventsWebView.delegate = self
        FGCUEventsWebView.loadWebPage(url: "http://thrive-fl.org/events/category/college-ministry/")
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
