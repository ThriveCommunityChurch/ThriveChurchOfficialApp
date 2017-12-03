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
        
        // Do any additional setup after loading the view.
        Webview.delegate = self
        loadMCView()
    }
    
    private func loadMCView() {
        let url = URL(string: "http://thrive-fl.org/mailing-list/")
        let request = URLRequest(url: url!)
        
        Webview.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loading.startAnimating()
        print("Loading....")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
        print("Stopped Loading!")
    }
    
}
