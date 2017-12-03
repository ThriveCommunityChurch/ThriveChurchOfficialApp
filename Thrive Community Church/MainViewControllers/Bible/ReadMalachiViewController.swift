//
//  ReadMalachiViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadMalachiViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var malachiView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        malachiView.delegate = self
        loadMalachiView()
    }
    
    private func loadMalachiView() {
        let url = URL(string: "https://www.bible.com/bible/59/mal.1")
        let request = URLRequest(url: url!)
        
        malachiView.loadRequest(request)
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
