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
	
    @IBAction func contactingAdmin(_ sender: AnyObject) {
		writeTextFile()
    }
	
	func writeTextFile() {
		
		// vars to add to the file
		let buildNum = build()
		let nowTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate())
		let uuid = UUID().uuidString.suffix(8)
		
		// Save data to file
		let fileName = "\(uuid.suffix(3))_info.log"
		let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory,
														  in: .userDomainMask,
														  appropriateFor: nil,
														  create: true)
		
		let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
		print("FilePath: \(fileURL.path)")
		
		let writeString = "Please do not modify the contents of this file." +
						"\n©2018. Thrive Community Church. All information collected is used solely for " +
						"\n\nApp Version: \(version())" +
						"\nDevice: \(UIDevice.current.modelName)" +
						"\niOS:\(UIDevice.current.systemVersion)" +
						"\nBuild #: \(buildNum)" +
						"\nCurrent Time: \(nowTimeStamp)"
		do {
			// Write to the file
			try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
		} catch let error as NSError {
			print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
		}
		
		if MFMailComposeViewController.canSendMail() {
			let uuid = UUID().uuidString.suffix(8)
			let composeVC = MFMailComposeViewController()
			
			composeVC.mailComposeDelegate = self
			composeVC.setToRecipients(["wyatt@thrive-fl.org"])
			composeVC.setSubject("Thrive iOS - ID: \(uuid)")
			
			if let fileData = NSData(contentsOfFile: fileURL.path) {
				composeVC.addAttachmentData(fileData as Data,
											mimeType: "text/txt",
											fileName: "\(uuid.suffix(3))_info.log")
			}

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
        return "\(version)"
    }
	
	func build() -> String {
		let dictionary = Bundle.main.infoDictionary!
		let build = dictionary["CFBundleVersion"] as! String
		return "\(build)"
	}
    
}
