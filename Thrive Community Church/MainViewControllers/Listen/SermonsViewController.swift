//
//  SermonsViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 5/22/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SermonsViewController: UIViewController, AVAudioPlayerDelegate, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var sermonView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        // Do any additional setup after loading the view, typically from a nib.
        sermonView.delegate = self
        sermonView.loadWebPage(url: "http://thrive-fl.org/teaching-series")
    	self.setLoadingSpinner(spinner: loading)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
       loading.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
    }
	
}
