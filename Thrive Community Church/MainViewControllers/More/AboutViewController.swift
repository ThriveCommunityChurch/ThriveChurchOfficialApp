//
//  AboutViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/23/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var appVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appVersion.text = "App Version: " + version()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // might add device logs via XGCLogger also in ~1.7
    @IBAction func contactingAdmin(_ sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            let uuid = String(UUID().uuidString.suffix(8))
            let composeVC = MFMailComposeViewController()
            
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["wyatt@thrive-fl.org"])
            composeVC.setSubject("Thrive iOS - ID: \(uuid)")
            present(composeVC, animated: true, completion: nil)
            self.present(composeVC, animated: true, completion: nil)
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
    
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        //let build = dictionary["CFBundleVersion"] as! String
        return "\(version)"
    }
}
