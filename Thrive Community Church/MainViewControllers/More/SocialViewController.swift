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
    
    @IBAction func openingTwitter(_ sender: AnyObject) {
		
		let twData = UserDefaults.standard.object(forKey: ConfigKeys.shared.TWUsername) as? Data
		
		var twUsername = "Thrive_FL"
		
		if twData != nil {
			
			// reading from the messageId collection in UD
			let decoded = NSKeyedUnarchiver.unarchiveObject(with: twData!) as! ConfigSetting
			
			twUsername = "\(decoded.Value ?? "Thrive_FL")"
		}
		
		let appURL = URL(string: "twitter:///user?screen_name=\(twUsername)")!
        
        if UIApplication.shared.canOpenURL(appURL) {
			UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        }
        else {
            let message = "You need to download the Twitter app first"
            let alert = UIAlertController(title: alertTitle,
                                  message: message,
                                  preferredStyle: UIAlertController.Style.alert)
            let cancelButton = UIAlertAction(title: cancel,
											 style: UIAlertAction.Style.destructive,
                                  handler: nil)
            let downloadTwitter = UIAlertAction(title: downloadTitle,
                                  style: UIAlertAction.Style.default,
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
    
    @IBAction func openingFacebook(_ sender: AnyObject) {
		
		let fbData = UserDefaults.standard.object(forKey: ConfigKeys.shared.FBPageID) as? Data
		
		var fbId = "157139164480128"
		
		if fbData != nil {
			
			// reading from the messageId collection in UD
			let decoded = NSKeyedUnarchiver.unarchiveObject(with: fbData!) as! ConfigSetting
			
			fbId = "\(decoded.Value ?? "157139164480128")"
		}
		
		let appURL = URL(string: "fb://profile/\(fbId)")!
		print(appURL.absoluteString)
		
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        }
        else {
            let message = "You need to download the Facebook app first"
            let alert = UIAlertController(title: alertTitle,
                                 message: message,
								 preferredStyle: UIAlertController.Style.alert)
            let cancelButton = UIAlertAction(title: cancel,
                                 style: UIAlertAction.Style.destructive,
                                 handler: nil)
            let downloadFacebook = UIAlertAction(title: downloadTitle,
                                 style: UIAlertAction.Style.default,
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
    
    @IBAction func openingInstagram(_ sender: AnyObject) {
		
		let igData = UserDefaults.standard.object(forKey: ConfigKeys.shared.IGUSername) as? Data
		
		var igUsername = "thrive_fl"
		
		if igData != nil {
			
			// reading from the messageId collection in UD
			let decoded = NSKeyedUnarchiver.unarchiveObject(with: igData!) as! ConfigSetting
			
			igUsername = "\(decoded.Value ?? "thrive_fl")"
		}
		
		let appURL = URL(string: "instagram://user?username=\(igUsername)")!
		
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        }
        else {
            let message = "You need to download the Instagram app first"
            let alert = UIAlertController(title: alertTitle,
                                  message: message,
								  preferredStyle: UIAlertController.Style.alert)
            let cancelButton = UIAlertAction(title: cancel,
											 style: UIAlertAction.Style.destructive,
                                  handler: nil)
            let downloadInstagram = UIAlertAction(title: downloadTitle,
												  style: UIAlertAction.Style.default,
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
