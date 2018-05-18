//
//  ReadGenesisViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 7/11/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadGenesisViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var genesisView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genesisView.delegate = self
        loadGenesisView()
        self.setLoadingSpinner(spinner: loading)
    }
    
    private func loadGenesisView() {
        let url = URL(string: "https://www.bible.com/bible/59/gen.1")
        let request = URLRequest(url: url!)
        
        genesisView.loadRequest(request)
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
