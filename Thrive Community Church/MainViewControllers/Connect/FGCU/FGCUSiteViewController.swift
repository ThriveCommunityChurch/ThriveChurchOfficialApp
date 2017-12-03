//
//  FGCUSiteViewController.swift
//  Thrive Church Official App
//
//  Created by Thrive on 9/9/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class FGCUSiteViewController: UIViewController, UIWebViewDelegate {


    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var FGCUWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view, typically from a nib.
        FGCUWebView.delegate = self
        loadFGCUView()
    }

    private func loadFGCUView() {
        let url = URL(string: "http://thrive-fl.org/youth/college/")
        let request = URLRequest(url: url!)
    
        FGCUWebView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
