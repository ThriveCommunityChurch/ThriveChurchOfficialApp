//
//  ReadAmosViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadAmosViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var amosView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amosView.delegate = self
        loadAmosView()
    }
    
    private func loadAmosView(){
        let url = URL(string: "https://www.bible.com/bible/59/amo.1")
        let request = URLRequest(url: url!)
        
        amosView.loadRequest(request)
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
