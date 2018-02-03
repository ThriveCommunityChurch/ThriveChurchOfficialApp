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
        
        /*      TODO: Call Parent View controller in order to load the view and also get
         the new Notes Loaded. Once they have loaded, segue back to this view.
         */
        
        detailViewController = self
		detailDescriptionLabel?.delegate = self
        detailViewController?.becomeFirstResponder()
        
        // called when adding / editing an item to the TableViewController in MasterVew
        // Called at application init for notes tab - YES
        
        // INIT NOTE #5 - No
        saveAndUpdate()
        self.configureView()
        
        // segue
        //INIT NOTE #8 - I assume that this is where the code stops.
        // Since no other funcs are called after config
    }
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            saveAndUpdate()
            self.configureView()
            
        }
    }
    
    // runs even before the segue happens
    func configureView() {
        // Update the user interface for the detail item.
        saveAndUpdate()
        //INIT NOTE #6 - No
        if objects.count == 0 {
            return
        }
        
        if let label = self.detailDescriptionLabel {
            label.text = objects[currentIndex]
            
            if label.text == BLANK_NOTE {
                label.text = ""
            }
        }
        // INIT NOTE #7 - After returning from our inital note we end here, on the
        // "Add Note" screen once again
    }
	
	// TODO: Fix this fully -- there's really only a hacky solution
	func textViewDidChangeSelection(_ textView: UITextView) {
		if let selectedRange = detailDescriptionLabel?.selectedTextRange {
			
			let cursorPosition = detailDescriptionLabel?.offset(from: (detailDescriptionLabel?.beginningOfDocument)!, to: selectedRange.start)
			
			let length = (cursorPosition ?? 0) - 1
			detailDescriptionLabel?.scrollRangeToVisible(NSRange(location: cursorPosition ?? 0, length: length))
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
	
    
    // called when hitting back on the editing screen -- after segue back to Table View
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        /*
         BINGO! - this is called when there is no note in the TableView
         this is also not called at any time before the user hits back after typing
         their first message
         
         Look here to make changes? -- more testing might be neeeded before we can
         make that assertion
        */
        if objects.count == 0 {
            return
        }
        // INIT NOTE #1 - Still nothing happening
        
        //updates the text for the preview of the note on the Table View
		if let indexText = detailDescriptionLabel?.text {
			objects[currentIndex] = indexText
			
			if detailDescriptionLabel?.text == "" {
				objects[currentIndex] = BLANK_NOTE
			}
		}
		
        saveAndUpdate()
        // Called wheb the view is returning from the editing view
    }
    
    // permiate changes to the master view
    func saveAndUpdate() {
        masterView?.save()
        masterView?.tableView.reloadData()
    }
}

class ActivityForNotesViewController: UIActivityViewController {
    
    //Remove actions that we do not want the user to be able to share via
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
