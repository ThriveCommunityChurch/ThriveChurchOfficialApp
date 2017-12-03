//
//  MeetTheTeamViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 7/6/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class MeetTheTeamViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var teamView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        teamView.delegate = self
        loadTeamView()
    }
    
    private func loadTeamView() {
        let url = URL(string: "http://thrive-fl.org/team")
        let request = URLRequest(url: url!)
        
        teamView.loadRequest(request)
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
