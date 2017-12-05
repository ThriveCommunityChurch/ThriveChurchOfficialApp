//
//  LoginInfoViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/4/17.
//  Copyright © 2017 Thrive Community Church. All rights reserved.
//

import UIKit
import Firebase

class LoginInfoViewContriller: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            let email = Auth.auth().currentUser?.email
            
            if Auth.auth().currentUser != nil {
                self.emailLabel.text = email
            }
            else if email == "unsubscribe@thrive-fl.org"{
                self.emailLabel.text = ""
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signOut(_ sender: Any) {
        print("Signing out")
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if Auth.auth().currentUser != nil {
                try! Auth.auth().signOut()
                self.emailLabel.text = "123@example.com"
                print("Signed Out")
            }
            else {
                let alertController = UIAlertController(title: "Error!",
                                                       message: "You are not logged in",
                                                       preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // End listener for Auth
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // Use this as an OOP function for checking the User's email / presenting the
    // Alert if a user isn't signed in
    func checkUserEmail() {
        
    }
    
    @IBAction func resetPW(_ sender: Any) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if Auth.auth().currentUser != nil {
                let email = Auth.auth().currentUser?.email
                let alertController = UIAlertController(title: "Are you sure?",
                                                        message: "Please check your email after confirming.",
                                                        preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "Yes",
                                                style: .default, handler: { (action) -> Void in
                    
                    if email == "unsubscribe@thrive-fl.org" {
                        print("You have been unsubscribed")
                    }
                    else {
                        print("Sending Email")
                        Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
                            print("Email Sent")
                        }
                    }
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                
                alertController.addAction(defaultAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: "Error!",
                                                        message: "You are not logged in",
                                                        preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
}
