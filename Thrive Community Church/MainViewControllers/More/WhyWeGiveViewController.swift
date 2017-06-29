//
//  WhyWeGiveViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 7/11/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class WhyWeGiveViewController: UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var whyGiveView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        whyGiveView.delegate = self
        loadWhyGiveView()
    }
    
    private func loadWhyGiveView() {
    
        let url = URL(string: "http://thrive-fl.org/why-give/")
        let request = URLRequest(url: url!)
    
        whyGiveView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webViewDidStartLoad(_ teamView: UIWebView) {
        loading.startAnimating()
        print("Loading....")
    }
    
    func webViewDidFinishLoad(_ teamView: UIWebView) {
        loading.stopAnimating()
        print("Stopped Loading!")
    }
}
