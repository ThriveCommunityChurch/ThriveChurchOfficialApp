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
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        print("Application is Active")
        
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        // Registering notifications
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
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        
        // End registration
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("Setting the player to play no matter what")
            
            // Uncommenting this didn't help allow for the Notifications to come through
            // it must be something to do with the Certificates
            UIApplication.shared.beginReceivingRemoteControlEvents()
            //print("Enabling Remote Control Events")
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
    
//*****************************************PushNotifications***********************************************************
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
//*********************************************************************************************************************
    
}
