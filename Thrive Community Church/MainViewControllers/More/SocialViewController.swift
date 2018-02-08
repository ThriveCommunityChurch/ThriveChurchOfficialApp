//
//  SocialViewController.swift
//  Thrive Church Official App
//
//  Created by Thrive on 2/20/17.
//  Copyright © 2017 Thrive Community Church. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController, UIApplicationDelegate {

    let alertTitle = "Alert"
    let cancel = "Cancel"
    let downloadTitle = "Download"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    let twitterID: URL = URL(string: "twitter:///user?screen_name=Thrive_FL")!
    @IBAction func openingTwitter(_ sender: AnyObject) {
        print("\nOpening in Twitter")
        
        if UIApplication.shared.canOpenURL(twitterID) {
            //checks to see if Twitter is installed
			UIApplication.shared.open(twitterID, options: [:], completionHandler: nil)
        }
        else {
            let message = "You need to download the Twitter app first"
            let alert = UIAlertController(title: alertTitle,
                                  message: message,
                                  preferredStyle: UIAlertControllerStyle.alert)
            let cancelButton = UIAlertAction(title: cancel,
                                  style: UIAlertActionStyle.destructive,
                                  handler: nil)
            let downloadTwitter = UIAlertAction(title: downloadTitle,
                                  style: UIAlertActionStyle.default,
                                      handler: { (action) -> Void in
                
                if let link = URL(string: "itms-apps://itunes.apple.com/app/id409789998"),
                    UIApplication.shared.canOpenURL(link) {
                    UIApplication.shared.open(link, options: [:], completionHandler: nil)
                }
            })
            alert.addAction(cancelButton)
            alert.addAction(downloadTwitter)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    let fbURLID: URL = URL(string: "fb://profile/157139164480128")!
    @IBAction func openingFacebook(_ sender: AnyObject) {
        print("\nOpening in Facebook")
        
        if UIApplication.shared.canOpenURL(fbURLID) {
            //checks to see if FB is installed
            UIApplication.shared.open(fbURLID, options: [:], completionHandler: nil)
        }
        else {
            let message = "You need to download the Facebook app first"
            let alert = UIAlertController(title: alertTitle,
                                 message: message,
                                 preferredStyle: UIAlertControllerStyle.alert)
            let cancelButton = UIAlertAction(title: cancel,
                                 style: UIAlertActionStyle.destructive,
                                 handler: nil)
            let downloadFacebook = UIAlertAction(title: downloadTitle,
                                 style: UIAlertActionStyle.default,
                                     handler: { (action) -> Void in
                
                if let link = URL(string: "itms-apps://itunes.apple.com/app/id284882215"),
                    UIApplication.shared.canOpenURL(link) {
					UIApplication.shared.open(link, options: [:], completionHandler: nil)
                }
            })
            alert.addAction(cancelButton)
            alert.addAction(downloadFacebook)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    let instagramHooks = "instagram://user?username=thrive_fl"
    @IBAction func openingInstagram(_ sender: AnyObject) {
        print("\nOpening in Insta")
        
        let instagramUrl = URL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl!) {
            UIApplication.shared.open(instagramUrl!, options: [:], completionHandler: nil)
        }
        else {
            let message = "You need to download the Instagram app first"
            let alert = UIAlertController(title: alertTitle,
                                  message: message,
                                  preferredStyle: UIAlertControllerStyle.alert)
            let cancelButton = UIAlertAction(title: cancel,
                                  style: UIAlertActionStyle.destructive,
                                  handler: nil)
            let downloadInstagram = UIAlertAction(title: downloadTitle,
                                  style: UIAlertActionStyle.default,
                                      handler: { (action) -> Void in
                
                if let link = URL(string: "itms-apps://itunes.apple.com/app/id389801252"),
                    UIApplication.shared.canOpenURL(link){
                    UIApplication.shared.open(link, options: [:], completionHandler: nil)
                }
            })
            alert.addAction(cancelButton)
            alert.addAction(downloadInstagram)
            
            
            present(alert, animated: true, completion: nil)
        }
    }
    
}
