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
                        Auth.auth().currentUser?.sendEmailVerification { (error) in
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
