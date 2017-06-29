//
//  ReadZepheniahViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadZepheniahViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var zepheniahView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zepheniahView.delegate = self
        loadZepheniahView()
    }
    
    private func loadZepheniahView(){
        let url = URL(string: "https://www.bible.com/bible/59/zep.1")
        let request = URLRequest(url: url!)
        
        zepheniahView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webViewDidStartLoad(_ Webview: UIWebView) {
        loading.startAnimating()
        print("Loading....")
        
    }
    
    func webViewDidFinishLoad(_ Webview: UIWebView) {
        loading.stopAnimating()
        print("Stopped Loading!")
    }
}
