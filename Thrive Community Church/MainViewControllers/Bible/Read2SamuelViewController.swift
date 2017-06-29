//
//  Read2SamuelViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class Read2SamuelViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var samuelView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        samuelView.delegate = self
        loadSamuelView()
    }
    
    private func loadSamuelView(){
        let url = URL(string: "https://www.bible.com/bible/59/2sa.1")
        let request = URLRequest(url: url!)
        
        samuelView.loadRequest(request)
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
