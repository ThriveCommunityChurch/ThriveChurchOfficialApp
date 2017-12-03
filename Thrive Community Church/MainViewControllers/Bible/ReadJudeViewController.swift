//
//  ReadJudeViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/2/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadJudeViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var judeView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        judeView.delegate = self
        loadJudeView()
    }
    
    private func loadJudeView() {
        let url = URL(string: "https://www.bible.com/bible/59/jud.1")
        let request = URLRequest(url: url!)
        
        judeView.loadRequest(request)
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
