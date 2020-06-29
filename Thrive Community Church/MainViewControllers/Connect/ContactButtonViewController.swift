//
//  ContactButtonViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/13/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit
import MessageUI

class ContactButtonViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emailUs(_ sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["info@thrive-fl.org"])
            present(composeVC, animated: true, completion: nil)
        }
		else {
			let alert = UIAlertController(title: "Error",
										  message: "Unable to perform selected action",
										  preferredStyle: .alert)
			
			let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
			
			alert.addAction(okAction)
			self.present(alert, animated: true, completion: nil)
		}
    }
    
    @IBAction func emailPastor(_ sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["john@thrive-fl.org"])
            present(composeVC, animated: true, completion: nil)
        }
		else {
			let alert = UIAlertController(title: "Error",
										  message: "Unable to perform selected action",
										  preferredStyle: .alert)
			
			let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
			
			alert.addAction(okAction)
			self.present(alert, animated: true, completion: nil)
		}
    }
    
    @IBAction func openPhoneToCall(_ sender: AnyObject) {
        
		let data = UserDefaults.standard.object(forKey: ConfigKeys.shared.PhoneMain) as? Data
		
		if data != nil {
			
			// reading from the messageId collection in UD
			let decoded = NSKeyedUnarchiver.unarchiveObject(with: data!) as! ConfigSetting
			
			if let url = URL(string: "tel://\(decoded.Value ?? "2396873430")"){
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
				print("Calling")
			}
		}
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                                                   error: Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
            
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
            
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
            
        case MFMailComposeResult.failed.rawValue:
            print("Error: \(String(describing: error?.localizedDescription))")
            
        default:
            
            break
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
