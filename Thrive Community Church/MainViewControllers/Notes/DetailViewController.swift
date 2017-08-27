//
//  DetailViewController.swift
//  notes
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Wyatt Baggett. All rights reserved.
//

import UIKit
//import CoreData -- in case we need it

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*      TODO: Call Parent View controller in order to load the view and also get
         the new Notes Loaded. Once they have loaded, segue back to this view.
         */
        
        detailViewController = self
        detailViewController?.becomeFirstResponder()
        
        // called when adding / editing an item to the TableViewController in MasterVew
        // Called at application init for notes tab? -- more testing is required
        saveAndUpdate()
        self.configureView()
        
        // segue
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
        
        if objects.count == 0 {
            return
        }
        // done
        if let label = self.detailDescriptionLabel {
            label.text = objects[currentIndex]
            
            if label.text == BLANK_NOTE {
                label.text = ""
            }
        }
    }
    
    @IBAction func share(_ sender: AnyObject) {
        let textToShare = detailDescriptionLabel.text!
        
        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems:
                                            objectsToShare ,
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
        
        if objects.count == 0 {
            return
        }
        
        //updates the text for the preview of the note on the Table View
        objects[currentIndex] = detailDescriptionLabel.text
        if detailDescriptionLabel.text == "" {
            objects[currentIndex] = BLANK_NOTE
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
