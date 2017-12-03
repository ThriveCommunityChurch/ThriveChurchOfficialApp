//
//  ReadProverbsViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class ReadProverbsViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var proverbsView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        proverbsView.delegate = self
        loadProverbsView()
    }
    
    private func loadProverbsView() {
        let url = URL(string: "https://www.bible.com/bible/59/pro.1")
        let request = URLRequest(url: url!)
        
        proverbsView.loadRequest(request)
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
