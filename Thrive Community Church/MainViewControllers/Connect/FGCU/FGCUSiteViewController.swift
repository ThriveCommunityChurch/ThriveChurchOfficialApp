//
//  FGCUSiteViewController.swift
//  Thrive Church Official App
//
//  Created by Thrive on 9/9/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class FGCUSiteViewController: UIViewController, UIWebViewDelegate {


    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var FGCUWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        FGCUWebView.delegate = self
        FGCUWebView.loadWebPage(url: "http://thrive-fl.org/youth/college/")
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
