//
//  ReadRevelationViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/2/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadRevelationViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var revView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        revView.delegate = self
        loadRevView()
    }
    
    private func loadRevView(){
        let url = URL(string: "https://www.bible.com/bible/59/rev.1")
        let request = URLRequest(url: url!)
        
        revView.loadRequest(request)
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
