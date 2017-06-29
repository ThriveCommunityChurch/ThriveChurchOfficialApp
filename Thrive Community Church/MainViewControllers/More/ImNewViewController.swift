//
//  ImNewViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/16/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ImNewViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var ImNew: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        ImNew.delegate = self
        loadImNewView()
    }
    
    private func loadImNewView() {
        let url = URL(string: "http://thrive-fl.org/im-new/")
        let request = URLRequest(url: url!)
        
        ImNew.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ ImNew: UIWebView) {
    loading.startAnimating()
    print("Loading....")
    
    }
    
    func webViewDidFinishLoad(_ ImNew: UIWebView) {
        loading.stopAnimating()
        print("Stopped Loading!")
    }
}
