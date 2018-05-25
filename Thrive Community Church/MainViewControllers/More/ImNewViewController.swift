//
//  ImNewViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/16/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ImNewViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var ImNew: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        ImNew.delegate = self
        ImNew.loadWebPage(url: "http://thrive-fl.org/im-new/")
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
