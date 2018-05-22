//
//  MeetTheTeamViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 7/6/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class MeetTheTeamViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var teamView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamView.delegate = self
        teamView.loadWebPage(url: "http://thrive-fl.org/team")
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
