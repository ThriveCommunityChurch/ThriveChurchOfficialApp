//
//  Read2PeterViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/2/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class Read2PeterViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var peterView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peterView.delegate = self
        loadPeterView()
        self.setLoadingSpinner(spinner: loading)
    }
    
    private func loadPeterView() {
        let url = URL(string: "https://www.bible.com/bible/59/2pe.1")
        let request = URLRequest(url: url!)
        
        peterView.loadRequest(request)
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
