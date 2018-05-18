//
//  ReadPsamlsViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadPsamlsViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var psalmView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        psalmView.delegate = self
        loadPsalmView()
        self.setLoadingSpinner(spinner: loading)
    }
    
    private func loadPsalmView() {
        let url = URL(string: "https://www.bible.com/bible/59/psa.1")
        let request = URLRequest(url: url!)
        
        psalmView.loadRequest(request)
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
