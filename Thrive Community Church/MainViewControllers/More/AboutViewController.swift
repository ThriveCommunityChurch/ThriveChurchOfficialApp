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

        appVersion.text = "v\(version())"
		navigationController?.title = "About"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    @IBAction func contactingAdmin(_ sender: AnyObject) {
		writeTextFile()
    }
	
	func writeTextFile() {
		
		// lets not create a fild on the user's device if they can't even send us an email
		if MFMailComposeViewController.canSendMail() {
		
			// vars to add to the file
			let buildNum = build()
			let uuid = UUID().uuidString.suffix(8)
			let date = getDate()
			
			// Save data to file
			let fileName = "\(uuid.suffix(3)).log"
			let documentDirURL = try! FileManager.default.url(for: .documentDirectory,
															  in: .userDomainMask,
															  appropriateFor: nil,
															  create: true)
			
			let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
				
			
			
			let year = Calendar.current.component(.year, from: Date())
			let writeString = "PLEASE DO NOT MODIFY THE CONTENTS OF THIS FILE\n" +
				"\n©\(year) Thrive Community Church. All information collected is used solely for product development and is never sold.\n" +
				"\n\nDevice Information" +
				"\nDevice: \(UIDevice.current.modelName)" +
				"\nCurrent Time: \(date)" +
				"\niOS: \(UIDevice.current.systemVersion)" +
				"\n\nApplication Information" +
				"\nVersion: \(version())" +
				"\nBuild #: \(buildNum)" +
			    "\nFeedback ID: \(uuid)"
			
			do {
				// Write to the file
				try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
				
				let composeVC = MFMailComposeViewController()
				
				composeVC.mailComposeDelegate = self
				composeVC.setToRecipients(["wyatt@thrive-fl.org"])
				composeVC.setSubject("Thrive iOS - ID: \(uuid)")
				
				if let fileData = NSData(contentsOfFile: fileURL.path) {
					composeVC.addAttachmentData(fileData as Data,
												mimeType: "text/txt",
												fileName: "\(uuid.suffix(5)).log")
				}
				self.present(composeVC, animated: true, completion: nil)
				
			} catch let error as NSError {
				print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
				
				self.displayAlertForAction()
			}
		}
		else {
			self.displayAlertForAction()
		}
	}
	
	@IBAction func privacyPolicy(_ sender: Any) {
		
		self.openUrlWithError(link: "http://thrive-fl.org/privacy#mobile")
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
	
	func getDate() -> String {
		
		let stringFromDate = Date().iso8601    // "2017-03-22T13:22:13.933Z"
		if let dateFromString = stringFromDate.dateFromISO8601 {
			return dateFromString.iso8601      // "2017-03-22T13:22:13.933Z"
		}
		return stringFromDate
	}
    
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as? String ?? ""
        return "\(version)"
    }
	
	func build() -> String {
		let dictionary = Bundle.main.infoDictionary!
		let build = dictionary["CFBundleVersion"] as? String ?? ""
		return "\(build)"
	}
    
}
