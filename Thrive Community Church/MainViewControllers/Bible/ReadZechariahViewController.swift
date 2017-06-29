//
//  ReadZechariahViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadZechariahViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var zecView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zecView.delegate = self
        loadZecView()
    }
    
    private func loadZecView(){
        let url = URL(string: "https://www.bible.com/bible/59/zec.1")
        let request = URLRequest(url: url!)
        
        zecView.loadRequest(request)
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
