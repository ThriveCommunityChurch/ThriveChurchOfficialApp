//
//  EspanolAboutThriveViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 7/13/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class EspanolAboutThriveViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var spanishAboutView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spanishAboutView.delegate = self
        loadspanishAboutView()
    }
    
    private func loadspanishAboutView() {
        let url = URL(string: "http://thrive-fl.org/thrive-en-espanol/about")
        let request = URLRequest(url: url!)
        
        spanishAboutView.loadRequest(request)
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
