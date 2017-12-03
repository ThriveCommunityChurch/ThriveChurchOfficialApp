//
//  ReadNehemiahViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadNehemiahViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var nehemiahiew: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nehemiahiew.delegate = self
        loadNehemiahView()
    }
    
    private func loadNehemiahView() {
        let url = URL(string: "https://www.bible.com/bible/59/neh.1")
        let request = URLRequest(url: url!)
        
        nehemiahiew.loadRequest(request)
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
