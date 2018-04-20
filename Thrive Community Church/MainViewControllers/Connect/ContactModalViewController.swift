//
//  ContactModalViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/1/17.
//  Copyright © 2017 Thrive Community Church. All rights reserved.
//

import UIKit
import MessageUI

class ContactModalViewController: UIViewController, MFMailComposeViewControllerDelegate {
    // Unused at this point
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews()
    }
    
    func loadViews() {
        //Making it look nice
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        //if the user taps outside the popUpView it will still dismiss the view
        let tapGestureRecognizer = UITapGestureRecognizer(
                      target: self,
                      action: #selector(tappedOutside(tapGestureRecognizer:)))
        mainView.isUserInteractionEnabled = true
        mainView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //TODO: May need to be altered to compile with Swift 4 @objc changes
    @objc func tappedOutside(tapGestureRecognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
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
        
        let tel = 2396873430 as UInt32
        if let url = URL(string: "tel://\(tel)"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            print("Calling")
        }
    }
    
    @IBAction func closeView(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    //Handling email request
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
        dismiss(animated: true, completion: nil)
    }
}
