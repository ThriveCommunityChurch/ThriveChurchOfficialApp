//
//  DetailViewControllerExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 11/29/17.
//  Copyright © 2017 Thrive Community Church. All rights reserved.
//

import UIKit
import Firebase

extension DetailViewController {
    
    // Might change this to be something using Auth instead - but in the meantime this works
    func uploadToFirebase() {
            
            // send this to the DB
            self.ref = Database.database().reference().child("notes")
            let key = self.ref.childByAutoId().key
                                            
            let note = ["id":key,
                        "note": detailDescriptionLabel.text!,
                        "takenBy": UUID().uuidString
            ]
        
            //adding the note inside the generated key
            self.ref.child(key).setValue(note)
    }
    
    func createAccount() {
        let alert = UIAlertController(title: "Create an account",
                                      message: "Your notes will be saved after you login.",
                                      preferredStyle: .alert)
        
        alert.addTextField { (emailField: UITextField) in
            emailField.keyboardAppearance = .dark
            emailField.keyboardType = .default
            emailField.autocorrectionType = .default
            emailField.placeholder = "123@example.com"
        }
        
        alert.addTextField { (passwordField: UITextField) in
            passwordField.keyboardAppearance = .dark
            passwordField.keyboardType = .default
            passwordField.autocorrectionType = .default
            passwordField.isSecureTextEntry = true
        }
        
        // Submit
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get TextFields text
            let emailTxt = alert.textFields![0]
            let passwordTxt = alert.textFields![1]
            
            self.register(email: emailTxt.text!, password: passwordTxt.text!)
            print("USERNAME: \(emailTxt.text!)\nPASSWORD: \(passwordTxt.text!)")
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func register(email: String, password: String) {
        if email == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
//            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//                self.createAccount()
//            })
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
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
