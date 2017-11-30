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
}
