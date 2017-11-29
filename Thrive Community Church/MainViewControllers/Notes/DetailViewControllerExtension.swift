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
    func registerForFirebase() {
        let alert = UIAlertController(title: "Please Login",
                                      message: "Enter a username and Password",
                                      preferredStyle: .alert)
        
        // Add the text fields
        alert.addTextField { (username: UITextField) in
            username.keyboardAppearance = .dark
            username.keyboardType = .default
            username.autocorrectionType = .default
            username.placeholder = "Username"
        }
        alert.addTextField{(password: UITextField) in
            password.keyboardAppearance = .dark
            password.keyboardType = .default
            password.placeholder = "Password"
            password.isSecureTextEntry = true
        }
        
        // submit button
        let loginAction = UIAlertAction(title: "Submit",
                                        style: .default,
                                        handler: { (action) -> Void in
                                            
            // Get entered text
            let usernameTxt = alert.textFields![0]
            let passwordTxt = alert.textFields![1]
            
            // send this to the DB
            self.ref = Database.database().reference().child("users")
            let key = self.ref.childByAutoId().key
                                            
            let user = ["id":key,
                        "username": usernameTxt.text!,
                        "password": passwordTxt.text!
            ]
            //adding the artist inside the generated unique key
            self.ref.child(key).setValue(user)
            
            self.notLoggedIn = false
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        // Add buttons & present
        alert.addAction(loginAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
