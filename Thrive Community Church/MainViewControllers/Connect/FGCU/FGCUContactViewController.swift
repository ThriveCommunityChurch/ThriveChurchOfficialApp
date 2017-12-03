//
//  FGCUContactViewController.swift
//  Thrive Church Official App
//
//  Created by Thrive on 9/9/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class FGCUContactViewController: UIViewController,  MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openPhoneToCall(_ sender: AnyObject) {
        
        let tel = 2396715685 as UInt32
        if let url = URL(string: "tel://\(tel)"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            print("Calling")
        }
        
    }
    
    @IBAction func openMessageToText(_ sender: AnyObject) {
        
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "";
        messageVC.recipients = ["2396715685"]
        messageVC.messageComposeDelegate = self;
        
        self.present(messageVC, animated: false, completion: nil)
    }
    
    @IBAction func emailUs(_ sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["phil@thrive-fl.org"])
            present(composeVC, animated: true, completion: nil)
            self.present(composeVC, animated: true, completion: nil)
            
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
            
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
            
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
            
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
            
        default:
            break;
        }
    }
}
