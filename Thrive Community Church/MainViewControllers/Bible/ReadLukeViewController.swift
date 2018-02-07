//
//  ReadLukeViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadLukeViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var lukeView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lukeView.delegate = self
        loadLukeView()
    }
    
    private func loadLukeView() {
        let url = URL(string: "https://www.bible.com/bible/59/luk.1")
        let request = URLRequest(url: url!)
        
        lukeView.loadRequest(request)
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
