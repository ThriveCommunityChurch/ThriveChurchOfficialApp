//
//  ReadHabakkukViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadHabakkukViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var habView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        habView.delegate = self
        loadHabView()
        self.setLoadingSpinner(spinner: loading)
    }
    
    private func loadHabView() {
        let url = URL(string: "https://www.bible.com/bible/59/hab.1")
        let request = URLRequest(url: url!)
        
        habView.loadRequest(request)
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
