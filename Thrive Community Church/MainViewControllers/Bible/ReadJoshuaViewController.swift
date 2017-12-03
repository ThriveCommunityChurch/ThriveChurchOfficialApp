//
//  ReadJoshuaViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 7/17/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadJoshuaViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var joshuaView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joshuaView.delegate = self
        loadJoshuaView()
    }
    
    private func loadJoshuaView() {
        let url = URL(string: "https://www.bible.com/bible/59/jos.1")
        let request = URLRequest(url: url!)
        
        joshuaView.loadRequest(request)
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
