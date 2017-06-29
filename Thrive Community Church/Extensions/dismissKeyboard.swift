//
//  dismissKeyboard.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 7/6/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
