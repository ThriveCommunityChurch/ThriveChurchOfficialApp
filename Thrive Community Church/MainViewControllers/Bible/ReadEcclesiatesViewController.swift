//
//  ReadEcclesiatesViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadEcclesiatesViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var ecclesiView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ecclesiView.delegate = self
        loadEcclesiView()
    }
    
    private func loadEcclesiView() {
        let url = URL(string: "https://www.bible.com/bible/59/ecc.1")
        let request = URLRequest(url: url!)
        
        ecclesiView.loadRequest(request)
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
