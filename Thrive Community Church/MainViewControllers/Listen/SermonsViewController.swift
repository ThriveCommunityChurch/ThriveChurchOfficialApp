//
//  SermonsViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 5/22/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SermonsViewController: UIViewController, AVAudioPlayerDelegate, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var sermonView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func shouldAutorotate() -> Bool {
            if (UIDevice.current.orientation == UIDeviceOrientation.portrait ||
                UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown ||
                UIDevice.current.orientation == UIDeviceOrientation.unknown) {
                return true
            }
            else {
                return false
            }
        }
        
        func supportedInterfaceOrientations() -> Int {
            return Int(UIInterfaceOrientationMask.portrait.rawValue) | Int(UIInterfaceOrientationMask.portraitUpsideDown.rawValue)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        sermonView.delegate = self
        loadSermonView()
    
    }
    
    private func loadSermonView(){
        let url = URL(string: "http://thrive-fl.org/teaching-series")
        let request = URLRequest(url: url!)
        
        sermonView.loadRequest(request)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
//    override func remoteControlReceivedWithEvent(event: UIEvent?) {
//        let rc = event!.subtype
//        print("does this work? \(rc.rawValue)")
//        // 101 is Pause... 100 is Play
//        //takePicture()
//    }
    
    func webViewDidStartLoad(_ sermonView: UIWebView) {
       loading.startAnimating()
        print("Loading....")
    }
    
    func webViewDidFinishLoad(_ sermonView: UIWebView) {
        loading.stopAnimating()
        print("Stopped Loading!")
    }
    
    
}
