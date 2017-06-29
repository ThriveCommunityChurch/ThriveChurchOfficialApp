//
//  EventsFeedViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 7/11/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class EventsFeedViewController: UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var eventsView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        eventsView.delegate = self
        loadEventsView()
    }
    
    private func loadEventsView() {
        let url = URL(string: "http://thrive-fl.org/events/list/")
        let request = URLRequest(url: url!)
        
        eventsView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ eventsView: UIWebView) {
        loading.startAnimating()
        print("Loading....")
        
    }
    
    func webViewDidFinishLoad(_ eventsView: UIWebView) {
        loading.stopAnimating()
        print("Stopped Loading!")
    }
}
