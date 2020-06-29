//
//  ThriveFGCUViewController.swift
//  Thrive Church Official App
//
//  Created by Thrive on 9/9/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ThriveFGCUViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openDirections(_ sender: AnyObject) {
		
		let data = UserDefaults.standard.object(forKey: ConfigKeys.shared.AddressMain) as? Data
		
		if data != nil {
			
			// reading from the messageId collection in UD
			let decoded = NSKeyedUnarchiver.unarchiveObject(with: data!) as! ConfigSetting
			
			let address = "\(decoded.Value ?? "Thrive Community Church")".replacingOccurrences(of: " ", with: "+")
			
			self.openUrlAnyways(link: "http://maps.apple.com/?daddr=\(address))&dirflg=d")
		}
        
    }
    
    @IBAction func feedback(_ sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            let uuid = UUID().uuidString.suffix(4)
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["wyatt@thrive-fl.org"])
            composeVC.setSubject("App Feedback - ID: \(uuid)")
            
            present(composeVC, animated: true, completion: nil)
            self.present(composeVC, animated: true, completion: nil)
        }
		else {
			self.displayAlertForAction()
		}
    }
	
	@IBAction func contactingThriveFGCU(_ sender: Any) {
		
		let data = UserDefaults.standard.object(forKey: ConfigKeys.shared.EmailMain) as? Data
		
		var email = ""
		
		if data != nil {
			
			// reading from the messageId collection in UD
			let decoded = NSKeyedUnarchiver.unarchiveObject(with: data!) as! ConfigSetting
			
			email = "\(decoded.Value ?? "info@thrive-fl.org")"
		}
		
		if MFMailComposeViewController.canSendMail() {
			
			let composeVC = MFMailComposeViewController()
			composeVC.mailComposeDelegate = self
			composeVC.setToRecipients([email])
			composeVC.setSubject("Thrive FGCU")
			present(composeVC, animated: true, completion: nil)
			self.present(composeVC, animated: true, completion: nil)
		}
		else {
			self.displayAlertForAction()
		}
	}
	
    //Standard Mail compose controller code
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
