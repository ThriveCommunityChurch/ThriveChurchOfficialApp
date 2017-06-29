//
//  EspanolSermonNotesViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 7/11/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class EspanolSermonNotesViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var spanishView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spanishView.delegate = self
        loadSpanishView()
    }
    
    private func loadSpanishView() {
        let url = URL(string: "http://thrive-fl.org/thrive-en-espanol")
        let request = URLRequest(url: url!)
        
        spanishView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webViewDidStartLoad(_ sermonView: UIWebView) {
        loading.startAnimating()
        print("Loading....")
    }
    
    func webViewDidFinishLoad(_ sermonView: UIWebView) {
        loading.stopAnimating()
        print("Stopped Loading!")
    }
}
