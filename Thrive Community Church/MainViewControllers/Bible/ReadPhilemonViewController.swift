//
//  ReadPhilemonViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/2/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadPhilemonViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var philView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        philView.delegate = self
        loadPhilView()
    }
    
    private func loadPhilView(){
        let url = URL(string: "https://www.bible.com/bible/59/phm.1")
        let request = URLRequest(url: url!)
        
        philView.loadRequest(request)
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
