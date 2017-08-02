//
//  ContactModalViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/17.
//  Copyright © 2017 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ContactModalViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var popUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Making it look nice
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func emailUs(_ sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["info@thrive-fl.org"])
            present(composeVC, animated: true, completion: nil)
            self.present(composeVC, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func emailPastor(_ sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["john@thrive-fl.org"])
            present(composeVC, animated: true, completion: nil)
            self.present(composeVC, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func openPhoneToCall(_ sender: AnyObject) {
        
        let tel = 2396873430 as UInt32
        if let url = URL(string: "tel://\(tel)"){
            UIApplication.shared.openURL(url)
            print("Calling")
        }
        
    }
    
    @IBAction func closeView(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
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
