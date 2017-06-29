//
//  ReadHaggaiVewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadHaggaiVewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var haggaiView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        haggaiView.delegate = self
        loadHaggaiView()
    }
    
    private func loadHaggaiView(){
        let url = URL(string: "https://www.bible.com/bible/59/hag.1")
        let request = URLRequest(url: url!)
        
        haggaiView.loadRequest(request)
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
