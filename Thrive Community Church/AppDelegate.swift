//
//  AppDelegate.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 5/22/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit
import AVFoundation
import CoreVideo
import MediaPlayer
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate, UNUserNotificationCenterDelegate  {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        print("Application is Active")
        
        // Registering notifications

        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })

        // For iOS 10 data message (sent via FCM)
        Messaging.messaging().delegate = self as? MessagingDelegate

        application.registerForRemoteNotifications()

        //End registration
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("Setting the player to play no matter what")
            
            UIApplication.shared.beginReceivingRemoteControlEvents()
            print("Enabling Remote Control Events")
        }
        catch {
            // report for an error
            print("Catches any errors with the AVPlayer")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        print("application Will Resign Active")
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
                print("error 1 caught")
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            print("error 2 caught")
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("application Did Enter Background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("application Will Enter Foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("application Did Become Active")
    }
    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground
        print("Will terminate")
    }
    
    // Use this method to perhaps advance the recording with a FF button?
    override func remoteControlReceived(with event: UIEvent?) {
        
        let rc = event!.subtype // = 2
        let rc1 = event!.type   // 101 is Pause... 100 is Play
        print("does this work? \(rc.rawValue)")
        print("does this work? \(rc1.rawValue)")
    }
    
    // FCM Token was updated - Firebase
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    // Provide APNSToken
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("Registration succeeded! Token: ", token)
    }
    
    // Failed Notifs registration
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed!")
    }
    
//*****************************************Recieve Notifications***********************
    
    // Firebase notification received
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification,
                withCompletionHandler completionHandler: @escaping (_ options: UNNotificationPresentationOptions) -> Void) {

        // Handle push while app is in the foreground
        print("Handle push from foreground\(notification.request.content.userInfo)")

        let dict = notification.request.content.userInfo["aps"] as! NSDictionary
        let d : [String : Any] = dict["alert"] as! [String : Any]
        let body : String = d["body"] as! String
        let title : String = d["title"] as! String
        print("Title:\(title) + body:\(body)")
        self.showLocalAlert(title: title, message: body, buttonTitle: "Dismiss", window: self.window!)
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) {
        // If you set a member variable in didReceiveRemoteNotification, you will know if this is from closed or background
        print("Handle push from background or closed\(response.notification.request.content.userInfo)")
    }

    // Show local notif if the application is in the Foreground
    func showLocalAlert(title: String, message: String, buttonTitle: String, window: UIWindow) {
        print("Foreground?")
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle,
                                      style: UIAlertActionStyle.default,
                                      handler: nil))
        window.rootViewController?.present(alert, animated: true,
                                      completion: nil)
    }
    
//*************************************************************************************
    
}
