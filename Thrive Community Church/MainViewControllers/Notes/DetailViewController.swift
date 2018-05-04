//
//  DetailViewController.swift
//  notes
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Wyatt Baggett. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var detailDescriptionLabel: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailViewController = self
		detailDescriptionLabel?.delegate = self
        detailViewController?.becomeFirstResponder()
        
        saveAndUpdate()
		// it is important that this be in here a second time -- notes have issues otherwise
        self.configureView()
    }
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            saveAndUpdate()
        }
    }
    
    // runs even before the segue happens
    func configureView() {
        // Update the user interface for the detail item.
        saveAndUpdate()
		
        if objects.count == 0 {
            return
        }
        
        if let label = self.detailDescriptionLabel {
            label.text = objects[currentIndex]
            
            if label.text == newNote {
                label.text = ""
            }
        }
    }
	
	// TODO: Fix this fully -- there's really only a hacky solution
	func textViewDidChangeSelection(_ textView: UITextView) {
		if let selectedRange = detailDescriptionLabel?.selectedTextRange {
			
			let cursorPosition = detailDescriptionLabel?.offset(from: (detailDescriptionLabel?.beginningOfDocument)!, to: selectedRange.start)
			
			let length = (cursorPosition ?? 0) - 1
			detailDescriptionLabel?.scrollRangeToVisible(NSRange(location: cursorPosition ?? 0,
																 length: length))
		}
	}
	
    @IBAction func share(_ sender: AnyObject) {
		let textToShare = detailDescriptionLabel?.text!
        
        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems:
                                            objectsToShare,
                                            applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = (sender) as? UIView
        self.present(activityVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// if the user types what we check for in order to inspect if the note is new
		// then add a space so it looks the same but isn't
		if detailDescriptionLabel?.text == "New Note" || detailDescriptionLabel?.text == "New Note " {
			detailDescriptionLabel?.text = "New Note "
		}
	}
    
    // called when hitting back on the editing screen -- after segue back to Table View
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
		
        if objects.count == 0 {
            return
        }
        
        // updates the text for the preview of the note on the Table View
		if let indexText = detailDescriptionLabel?.text {
			objects[currentIndex] = indexText
			
			if detailDescriptionLabel?.text == "" {
				objects[currentIndex] = newNote
			}
		}
		
        saveAndUpdate()
    }
    
    // permiate changes to the master view
    func saveAndUpdate() {
        masterView?.save()
        masterView?.tableView.reloadData()
    }
	
}

class ActivityForNotesViewController: UIActivityViewController {
    
    // Remove actions that we do not want the user to be able to share via
    // these are intentionally marked because the media is Text
    internal func _shouldExcludeActivityType(_ activity: UIActivity) -> Bool {
        let activityTypesToExclude = [
            "com.apple.reminders.RemindersEditorExtension",
            UIActivityType.openInIBooks,
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.postToWeibo,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo,
            "com.google.Drive.ShareExtension",
            "com.apple.mobileslideshow.StreamShareService"
        ] as [Any]
        
        if let actType = activity.activityType {
            if activityTypesToExclude.contains(where: { (Any) -> Bool in
                return true
            }) {
                return true
            }
            else if super.excludedActivityTypes != nil {
                return super.excludedActivityTypes!.contains(actType)
            }
        }
        return false
    }
    
}
