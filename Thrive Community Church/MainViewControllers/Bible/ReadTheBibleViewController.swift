//
//  Read1JohnViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/2/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class Read1JohnViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var johnView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        johnView.delegate = self
        loadJohnView()
    }
    
    private func loadJohnView() {
        let url = URL(string: "https://www.bible.com/bible/59/1jn.1")
        let request = URLRequest(url: url!)
        
        johnView.loadRequest(request)
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
