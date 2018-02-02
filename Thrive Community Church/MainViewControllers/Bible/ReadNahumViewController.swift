//
//  ReadNahumViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadNahumViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var nahumView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nahumView.delegate = self
        loadNahumView()
    }
    
    private func loadNahumView() {
        let url = URL(string: "https://www.bible.com/bible/59/nam.1")
        let request = URLRequest(url: url!)
        
        nahumView.loadRequest(request)
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
