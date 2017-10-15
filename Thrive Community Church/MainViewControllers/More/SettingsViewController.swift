//
//  SettingsViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/6/17.
//  Copyright © 2017 Thrive Community Church. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var notificationDescription: UILabel!
    @IBOutlet weak var notifImageView: UIImageView!
    @IBOutlet weak var notifSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNotifView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureNotifView() {
        notificationDescription.text = "Notifications Enabled"
        notifImageView.image = #imageLiteral(resourceName: "notifications_EN")
    }
    
    func disableNotifView() {
        notificationDescription.text = "Notifications Disabled"
        notifImageView.image = #imageLiteral(resourceName: "notifications_DIS")
    }
    
    @IBAction func limitCellular(_ sender: Any) {
        
        let alert = UIAlertController(title: "Notice!",
                  message: "Disabling Cellular Data may affect the performance of the" +
                  " application. Doing this is only reccomended when connected to a WiFi network.",
                  preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continue",
                  style: UIAlertActionStyle.default,
                  handler: { action in
                        self.goToSettings()
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                    style: UIAlertActionStyle.destructive,
                                    handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func toggleNotifs(_ sender: Any) {
        
        if (notifSwitch.isOn) {
            // Registering
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
            }
            
            UIApplication.shared.registerForRemoteNotifications()
            // Takes a second so notify the user at the end
            configureNotifView()
        }
        // else by itself caused issues
        else if (!notifSwitch.isOn) {
            disableNotifView()
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    
    func goToSettings () {
        
        if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
            else {
                print("You have iOS, \(UIDevice.current.systemVersion)")
                
                let alert = UIAlertController(title: "Oops!",
                                             message: "Your device isn't currently running iOS 10" +
                        " Access the settings by going to Settings -> Thrive Community Church",
                                             preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Continue",
                                            style: UIAlertActionStyle.default,
                                            handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
