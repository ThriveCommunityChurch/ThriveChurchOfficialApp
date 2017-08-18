//
//  GiveViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 5/31/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

// Page was edited to reflect the rejected review from Apple
// you cannot display a donation page inside the application. It must be taken
// into safari. - NO Exceptions


import Foundation
import UIKit

class giveViewController: UIViewController, UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // open the application in safari
    @IBAction func donation(_ sender: AnyObject) {
        
        let url = URL(string: "https://goo.gl/bSrZ9K")
        
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.openURL(url!)
        }
        else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
