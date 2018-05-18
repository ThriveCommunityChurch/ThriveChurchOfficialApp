//
//  ReadMicahViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadMicahViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var micahView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        micahView.delegate = self
        loadMicahView()
        self.setLoadingSpinner(spinner: loading)
    }
    
    private func loadMicahView() {
        let url = URL(string: "https://www.bible.com/bible/59/mic.1")
        let request = URLRequest(url: url!)
        
        micahView.loadRequest(request)
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
