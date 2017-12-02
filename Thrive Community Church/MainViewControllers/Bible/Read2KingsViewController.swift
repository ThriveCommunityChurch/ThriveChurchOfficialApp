//
//  Read2KingsViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class Read2KingsViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var kingsView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kingsView.delegate = self
        loadKingsView()
    }
    
    private func loadKingsView() {
        let url = URL(string: "https://www.bible.com/bible/59/2ki.1")
        let request = URLRequest(url: url!)
        
        kingsView.loadRequest(request)
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
