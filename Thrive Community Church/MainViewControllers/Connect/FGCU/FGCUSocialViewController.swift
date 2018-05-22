//
//  FGCUSocialViewController.swift
//  Thrive Church Official App
//
//  Created by Thrive on 9/9/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class FGCUSocialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func facebookButton(_ sender: AnyObject) {
		
		guard let fbURLID = URL(string: "fb://profile/587219548105074") else { return }
		guard let fbURL = URL(string: "https://www.facebook.com/thriveFGCU/") else { return }
        
        if UIApplication.shared.canOpenURL(fbURLID) {
			UIApplication.shared.open(fbURL, options: [:], completionHandler: nil)
        }
        else {
           UIApplication.shared.open(fbURL, options: [:], completionHandler: nil)
       }
    }
    
    @IBAction func instagramButton(_ sender: AnyObject) {
		
		guard let instagramLink = URL(string: "instagram://user?username=thrivefgcu") else { return }
		guard let instaURL = URL(string: "https://www.instagram.com/thrivefgcu/") else { return }
        
        if UIApplication.shared.canOpenURL(instagramLink) {
            UIApplication.shared.open(instagramLink, options: [:], completionHandler: nil)
        }
        else {
            UIApplication.shared.open(instaURL, options: [:], completionHandler: nil)
        }
    }
}
