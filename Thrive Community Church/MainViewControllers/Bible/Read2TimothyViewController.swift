//
//  Read2TimothyViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/2/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class Read2TimothyViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var timView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timView.delegate = self
        loadTimView()
    }
    
    private func loadTimView() {
        let url = URL(string: "https://www.bible.com/bible/59/2ti.1")
        let request = URLRequest(url: url!)
        
        timView.loadRequest(request)
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
