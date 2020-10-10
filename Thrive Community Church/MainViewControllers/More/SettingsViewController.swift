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
		
		navigationController?.title = "Settings"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func limitCellular(_ sender: Any) {
        
        let alert = UIAlertController(title: "Notice!",
                  message: "Disabling Cellular Data may affect the performance of the" +
                  " application. Doing this is only reccomended when connected to a WiFi network.",
				  preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Continue",
									  style: UIAlertAction.Style.destructive,
                  handler: { action in
                        self.goToSettings()
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
									  style: UIAlertAction.Style.cancel,
                                    handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func goToSettings () {
        
		if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
            else {
                print("You have iOS, \(UIDevice.current.systemVersion)")
                
                let alert = UIAlertController(title: "Oops!",
                                             message: "Your device isn't currently running iOS 10" +
                        " Access the settings by going to Settings -> Thrive Community Church",
											 preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Continue",
                                            style: UIAlertAction.Style.default,
                                            handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
	
}
