//
//  DetailViewController.swift
//  notes
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Wyatt Baggett. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    
    // detailDescView = Note area
    @IBOutlet weak var detailDescriptionLabel: UITextView!
    var notLoggedIn = true
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle! = nil
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    var savedNote: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*      TODO: Call Parent View controller in order to load the view and also get
         the new Notes Loaded. Once they have loaded, segue back to this view.
         */
        
        detailViewController = self
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Listen for Auth State changes
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if Auth.auth().currentUser != nil {
                // User is signed in.
                print("User is logged in")
            } else {
                // Login OR Register -- only if their email is not on file
                print("Not Logged in")
                self.loginToAccount()
            }
            
//            self.checkIfNoteExistsInDB(Note: self.detailDescriptionLabel.text!) { (result) in
//
//                if result {
//                    // nothing - it exists already
//                    self.uploadButton.image = #imageLiteral(resourceName: "UploadedToCloud")
//                }
//                else {
//                    print("Not in DB - Doing nothing on screen load")
//                }
//            }
        }
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
        
        // End listener for Auth
        Auth.auth().removeStateDidChangeListener(handle!)
        
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
    
    @IBAction func uploadToCloud(_ sender: Any) {
        uploadToFirebase()
        saveAndUpdate()
    }
    
}
