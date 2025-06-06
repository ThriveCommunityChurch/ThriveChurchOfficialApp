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


import UIKit

class giveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // opens the application in safari
    @IBAction func donation(_ sender: AnyObject) {
        
		let data = UserDefaults.standard.object(forKey: ConfigKeys.shared.Give) as? Data
		
		var giveLink = "https://goo.gl/bSrZ9K"
		
		if data != nil {
			
			// reading from the messageId collection in UD
			let decoded = NSKeyedUnarchiver.unarchiveObject(with: data!) as! ConfigSetting
			
			giveLink = "\(decoded.Value ?? "https://goo.gl/bSrZ9K")"
		}
		
		
        let encodedURL = giveLink.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

		let url = URL(string: encodedURL)!
        
        if UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
