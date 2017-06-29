//
//  SmallGroupViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/24/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class SmallGroupViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var smallGroup: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        smallGroup.delegate = self
        loadSmallGroupView()
    }
    
    private func loadSmallGroupView() {
        let url = URL(string: "http://thrive-fl.org/join-small-group")
        let request = URLRequest(url: url!)
        
        smallGroup.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
