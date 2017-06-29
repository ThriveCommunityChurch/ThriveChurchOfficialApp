//
//  PrayerRequestsViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/20/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class PrayerRequestsViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var prayerRequestsView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        prayerRequestsView.delegate = self
        loadPrayerRequestView()
        
    }
    
    private func loadPrayerRequestView() {
        let url = URL(string: "http://thrive-fl.org/prayer-requests")
        let request = URLRequest(url: url!)
        
        prayerRequestsView.loadRequest(request)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ serveWebView: UIWebView) {
        loading.startAnimating()
        print("Loading....")
    }
    
    func webViewDidFinishLoad(_ serveWebView: UIWebView) {
        loading.stopAnimating()
        print("Stopped Loading!")
    }
}
