//
//  SettingsViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/6/17.
//  Copyright © 2017 Thrive Community Church. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func limitCellular(_ sender: Any) {
        
        if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            } else {
                print("You have iOS, \(UIDevice.current.systemVersion)")
            }
        }
    }
}
