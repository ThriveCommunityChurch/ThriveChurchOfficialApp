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
    
    // MARK: Saving Note
    // Might change this to be something using Auth instead - but in the meantime this works
    func uploadToFirebase() {
        print("Uploading to Firebase")
            
        // send this to the DB
        self.ref = Database.database().reference().child("notes")
        let key = self.ref.childByAutoId().key
    
        //let user = Auth.auth().currentUser
        //let uid = user?.uid

        // detect if there is a note of the same text in the DB alerady
        
//        checkIfNoteExistsInDB(Note: self.detailDescriptionLabel.text!) { (result) in
//
//            if result {
//                // nothing - it exists already
//                self.uploadButton.image = #imageLiteral(resourceName: "UploadedToCloud")
//            }
//            else {
//                print("Uploading to FB DB")
//                //                let note = ["id":key,
//                //                            "note": self.detailDescriptionLabel.text!,
//                //                            "takenBy": uid
//                //                ]
//                //
//                //                //adding the note inside the generated key
//                //                self.ref.child(key).setValue(note)
//                //                self.uploadButton.image = #imageLiteral(resourceName: "UploadedToCloud")
//                self.uploadButton.image = #imageLiteral(resourceName: "UploadedToCloud")
//            }
//        }
    }
    
    // Fix this to return bool so we can check and assign this in the middle of the viewDidLoad
    // NIL WHILE UNWRAPPING VALUE
//    func checkIfNoteExistsInDB(Note: String, finishedClosured:@escaping ((Bool)->Void))  {
//
//        //let user = Auth.auth().currentUser
//        //let uid = user?.uid
//
//        // detect if there is a note of the same text in the DB alerady
//        self.ref.observe(.value, with: { snapshot in
//
//            // all notes
//            for _ in snapshot.children {
//                let key = snapshot.key
//                guard let savedNote = snapshot.childSnapshot(forPath: "\(key)/note").value
//                    else {
//                        self.savedNote = "New Note"
//                        return
//                }
//            }
//            if self.savedNote == self.detailDescriptionLabel.text ?? "New Note" {
//                self.uploadButton.image = #imageLiteral(resourceName: "UploadedToCloud")
//                finishedClosured(true)
//            }
//            else {
//                finishedClosured(false)
//            }
//        }) { (error) in
//            print(error.localizedDescription)
//            finishedClosured(false)
//        }
//    }
    
    // MARK: Account Services
    // if user exists
    func loginToAccount() {
        print("Logging In")
        let alert = UIAlertController(title: "Please Login",
                                      message: "Your notes will be saved after you login.",
                                      preferredStyle: .alert)
        
        alert.addTextField { (emailField: UITextField) in
            emailField.keyboardAppearance = .dark
            emailField.keyboardType = .default
            emailField.autocorrectionType = .default
            emailField.returnKeyType = .next
            emailField.placeholder = "123@example.com"
        }
        
        alert.addTextField { (passwordField: UITextField) in
            passwordField.keyboardAppearance = .dark
            passwordField.keyboardType = .default
            passwordField.autocorrectionType = .default
            passwordField.returnKeyType = .done
            passwordField.isSecureTextEntry = true
        }
        
        // Submit
        let submitAction = UIAlertAction(title: "Submit",
                                         style: .default, handler: { (action) -> Void in
            // Get TextFields text
            let emailTxt = alert.textFields![0]
            let passwordTxt = alert.textFields![1]
            
            self.login(email: emailTxt.text!, password: passwordTxt.text!)
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel",
                                   style: .destructive, handler: { (action) -> Void in
                                    
            let alert = UIAlertController(title: "Are you Sure?",
                                          message: "If you tap Yes you won't be prompted anymore to create an account",
                                          preferredStyle: .alert)
            
            // Submit
            let submitAction = UIAlertAction(title: "Yes",
                 style: .destructive, handler: { (action) -> Void in
                    
                    // Turn off notifications by registering the user with a fake account
                    // hacky but That's the only thing I could think of to fix the issue of alerts popping all the time
                    let emailID = String(UUID().uuidString.suffix(4))
                    Auth.auth().signIn(withEmail: "\(emailID)@thrive-fl.org", password: "123456") { (user, error) in
                        print("Logged into fake account")
                    }
            })
            
            // No button
            let cancel = UIAlertAction(title: "No", style: .default, handler: nil)
            
            alert.addAction(submitAction)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            
        
        })
        
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // if user does not exist
    func createAccount() {
        print("Creating Account")
        let alert = UIAlertController(title: "Create An Account",
                                      message: "Your notes will be saved after you create your account. Please ensure that the email is valid as password resets will be sent to this address.",
                                      preferredStyle: .alert)
        
        alert.addTextField { (emailField: UITextField) in
            emailField.keyboardAppearance = .dark
            emailField.keyboardType = .default
            emailField.autocorrectionType = .default
            emailField.returnKeyType = .next
            emailField.placeholder = "123@example.com"
        }
        
        alert.addTextField { (passwordField: UITextField) in
            passwordField.keyboardAppearance = .dark
            passwordField.keyboardType = .default
            passwordField.autocorrectionType = .default
            passwordField.returnKeyType = .done
            passwordField.isSecureTextEntry = true
        }
        
        // Submit
        let submitAction = UIAlertAction(title: "Submit",
                                         style: .default, handler: { (action) -> Void in
            // Get TextFields text
            let emailTxt = alert.textFields![0]
            let passwordTxt = alert.textFields![1]
            
            self.register(email: emailTxt.text!, password: passwordTxt.text!)
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func login(email: String, password: String) {
        print("Attepting to login")
        if email == "" {
            let alertController = UIAlertController(title: "Error",
                                                    message: "Please do not leave the email field blank",
                                                    preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK",
                                              style: .default, handler: { (action) -> Void in
                self.loginToAccount()
            })
            
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().fetchProviders(forEmail: email, completion: { (stringArray, error) in
                if error != nil {
                    print(error!)
                }
                else {
                    if stringArray == nil {
                        print("That account does not exist")
                        self.createAccount()
                    } else {
                        print("Account exists - Logging you in")
                        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                            
                            if error == nil {
                                print("You have successfully signed in")
                                
                            }
                            else {
                                let alertController = UIAlertController(title: "Error",
                                                                        message: error?.localizedDescription,
                                                                        preferredStyle: .alert)
                                
                                let defaultAction = UIAlertAction(title: "OK",
                                                                  style: .cancel, handler: { (action) -> Void in
                                                                    self.loginToAccount()
                                })
                                alertController.addAction(defaultAction)
                                
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }

                    }
                }
            })
        }
    }
    
    // Mark: Register w/ Account Info
    // Called at app startup
    func register(email: String, password: String) {
        print("Attepting to register")
        if email == "" {
            let alertController = UIAlertController(title: "Error",
                                                  message: "Please enter your email and password",
                                                  preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK",
                                              style: .default, handler: { (action) -> Void in
                self.createAccount()
            })
            
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
                        self.createAccount()
                    })
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
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
