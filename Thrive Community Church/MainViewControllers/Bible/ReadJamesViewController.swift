//
//  ReadJamesViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/2/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadJamesViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var jamesView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jamesView.delegate = self
        loadJamesView()
    }
    
    private func loadJamesView() {
        let url = URL(string: "https://www.bible.com/bible/59/jas.1")
        let request = URLRequest(url: url!)
        
        jamesView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
