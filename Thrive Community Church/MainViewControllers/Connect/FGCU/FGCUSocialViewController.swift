//
//  FGCUSocialViewController.swift
//  Thrive Church Official App
//
//  Created by Thrive on 9/9/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

class FGCUSocialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func facebookButton(_ sender: AnyObject) {
        
        let fbURLID: URL = URL(string: "fb://profile/587219548105074")!
        let fbURL: URL = URL(string: "https://www.facebook.com/thriveFGCU/")!
        
        if UIApplication.shared.canOpenURL(fbURLID){
            //checks to see if FB is installed
            UIApplication.shared.openURL(fbURLID)
        }
        else{
           UIApplication.shared.openURL(fbURL)
       }
    }
    
    @IBAction func instagramButton(_ sender: AnyObject) {
        
        let instagramHooks = "instagram://user?username=thrivefgcu"
        let instaURL = URL(string: "https://www.instagram.com/thrivefgcu/")!
        let instagramUrl = URL(string: instagramHooks)
        
        if UIApplication.shared.canOpenURL(instagramUrl!) {
            UIApplication.shared.openURL(instagramUrl!)
            print("opened in app")
        }
        else{
            UIApplication.shared.openURL(instaURL)
        }
    }
}
