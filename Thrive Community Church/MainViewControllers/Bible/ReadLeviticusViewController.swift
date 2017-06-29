//
//  ReadLeviticusViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 7/16/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadLeviticusViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var leviticusView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leviticusView.delegate = self
        loadLeviticusView()
    }
    
    private func loadLeviticusView(){
        let url = URL(string: "https://www.bible.com/bible/59/lev.1")
        let request = URLRequest(url: url!)
        
        leviticusView.loadRequest(request)
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
