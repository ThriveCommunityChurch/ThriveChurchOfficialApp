//
//  ReadSolomanViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadSolomanViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var solomanView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        solomanView.delegate = self
        loadSolomanView()
    }
    
    private func loadSolomanView() {
        let url = URL(string: "https://www.bible.com/bible/59/sng.1")
        let request = URLRequest(url: url!)
        
        solomanView.loadRequest(request)
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
