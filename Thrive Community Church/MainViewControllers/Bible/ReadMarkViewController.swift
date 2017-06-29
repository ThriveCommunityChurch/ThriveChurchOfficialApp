//
//  ReadMarkViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadMarkViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var markView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        markView.delegate = self
        loadMarkView()
    }
    
    private func loadMarkView(){
        let url = URL(string: "https://www.bible.com/bible/59/mrk.1")
        let request = URLRequest(url: url!)
        
        markView.loadRequest(request)
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
