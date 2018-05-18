//
//  ReadIsaiahViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadIsaiahViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var isaiahView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isaiahView.delegate = self
        loadIsaiahView()
        self.setLoadingSpinner(spinner: loading)
    }
    
    private func loadIsaiahView() {
        let url = URL(string: "https://www.bible.com/bible/59/isa.1")
        let request = URLRequest(url: url!)
        
        isaiahView.loadRequest(request)
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
