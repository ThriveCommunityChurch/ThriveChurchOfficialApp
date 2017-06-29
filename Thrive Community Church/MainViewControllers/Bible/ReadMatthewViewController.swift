//
//  ReadMatthewViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadMatthewViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var matthewView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        matthewView.delegate = self
        loadMatthewView()
    }
    
    private func loadMatthewView(){
        let url = URL(string: "https://www.bible.com/bible/59/mat.1")
        let request = URLRequest(url: url!)
        
        matthewView.loadRequest(request)
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
