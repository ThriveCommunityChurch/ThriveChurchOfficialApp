//
//  FGCUEventsViewController.swift
//  Thrive Church Official App
//
//  Created by Thrive on 9/9/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class FGCUEventsViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var FGCUEventsWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        FGCUEventsWebView.delegate = self
        loadFGCUEventsView()
    }
    
    private func loadFGCUEventsView() {
        let url = URL(string: "http://thrive-fl.org/events/category/college-ministry/")
        let request = URLRequest(url: url!)
        
        FGCUEventsWebView.loadRequest(request)
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
