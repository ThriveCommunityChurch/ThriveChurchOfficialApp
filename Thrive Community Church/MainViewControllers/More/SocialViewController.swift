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
    
    let twitterID: String = "twitter:///user?screen_name=Thrive_FL"
    @IBAction func openingTwitter(_ sender: AnyObject) {
		
		guard let profileLink = URL(string: twitterID) else { return }
        
        if UIApplication.shared.canOpenURL(profileLink) {
			UIApplication.shared.open(profileLink, options: [:], completionHandler: nil)
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
    
	let fbURLID: String = "fb://profile/157139164480128"
    @IBAction func openingFacebook(_ sender: AnyObject) {

		guard let profileLink = URL(string: fbURLID) else { return }
		
        if UIApplication.shared.canOpenURL(profileLink) {
            UIApplication.shared.open(profileLink, options: [:], completionHandler: nil)
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
		
		guard let instagramUrl = URL(string: instagramHooks) else { return }
		
        if UIApplication.shared.canOpenURL(instagramUrl) {
            UIApplication.shared.open(instagramUrl, options: [:], completionHandler: nil)
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
                    UIApplication.shared.canOpenURL(link) {
                    UIApplication.shared.open(link, options: [:], completionHandler: nil)
                }
            })
            alert.addAction(cancelButton)
            alert.addAction(downloadInstagram)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
}
