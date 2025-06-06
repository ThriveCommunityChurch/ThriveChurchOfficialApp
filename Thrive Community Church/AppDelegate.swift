//
//  AppDelegate.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 5/22/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import CoreVideo
import MediaPlayer
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
		launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        print("Application is Active")
        
        do {
			try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            print("Setting the player to play no matter what")
            
            UIApplication.shared.beginReceivingRemoteControlEvents()
            print("Enabling Remote Control Events")
        }
        catch {
            // report for an error
            print("Catches any errors with the AVPlayer")
        }
		
		// configure firebase for analytics events
		FirebaseApp.configure()
	
		Analytics.logEvent(AnalyticsEventAppOpen, parameters: [
			AnalyticsParameterItemID: "id-AppOpen",
			AnalyticsParameterItemName: "AppOpen",
			AnalyticsParameterContentType: "cont"
		])
			
		UNUserNotificationCenter.current().delegate = self
		Messaging.messaging().delegate = self
		
		let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
		UNUserNotificationCenter.current().requestAuthorization(
		  options: authOptions,
		  completionHandler: {_, _ in })
		
		application.registerForRemoteNotifications()
				
		UpdateCacheForAPIDomain()
		
        ConfigurationExtension.RetrieveConfigurations()
		
		// REACHABILITY
		do {
			Network.reachability = try Reachability(hostname: "www.google.com")
			do {
				try Network.reachability?.start()
			} catch let error as Network.Error {
				print(error)
			} catch {
				print(error)
			}
		} catch {
			print(error)
		}
		
        return true
    }
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		Messaging.messaging().apnsToken = deviceToken
		
		// Make sure that firebase has this APN token so that it knows where to send the notification
		Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.prod)
	}
	
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
		
		Messaging.messaging().token { token, error in
			
			if (fcmToken == token) {
				print("FCM Tokens match!")
			}
			
			if let error = error {
				print("Error fetching FCM registration token: \(error)")
			}
			else if let token = token {
				print("FCM registration token: \(token)")
			}
		}

		let dataDict:[String: String] = ["token": fcmToken ?? "" ]
	  
		NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
	}
	
	// Receive displayed notifications for iOS 10 devices.
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification,
	  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		
	    let userInfo = notification.request.content.userInfo

	    // With swizzling disabled you must let Messaging know about the message, for Analytics
	    Messaging.messaging().appDidReceiveMessage(userInfo)
		
		
	    // Change this to your preferred presentation option
        completionHandler([[.badge, .sound]])
	}

	func userNotificationCenter(_ center: UNUserNotificationCenter,
								didReceive response: UNNotificationResponse,
								withCompletionHandler completionHandler: @escaping () -> Void) {
		
		  let userInfo = response.notification.request.content.userInfo

		  // With swizzling disabled you must let Messaging know about the message, for Analytics
		  Messaging.messaging().appDidReceiveMessage(userInfo)

		  completionHandler()
	}

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        print("application Will Resign Active")
        
        do {
			try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
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
		
		Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
			AnalyticsParameterItemID: "id-AppInBackground",
			AnalyticsParameterItemName: "AppInBackground",
			AnalyticsParameterContentType: "cont"
		])
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
		
        print("application Will Enter Foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		
		// we can only reset this on each application launch AFTER we're registered for notifications
		UIApplication.shared.applicationIconBadgeNumber = 0
		
        print("application Did Become Active")
    }
    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground
        print("Will terminate")
    }
	
	private func UpdateCacheForAPIDomain() {
		
		let apiCacheKey = ApplicationVariables.ApiCacheKey
		var apiDomain = "nil"
		
		var nsDictionary: NSDictionary?
		
		// check the cache first, if it's not there then look in the Plist
		if let loadedData = UserDefaults.standard.string(forKey: apiCacheKey) {
			
			apiDomain = loadedData
			
			// look to see if this is different, if not do nothing different
			if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
				nsDictionary = NSDictionary(contentsOfFile: path)
				
				let apiString = nsDictionary?[apiCacheKey] as? String ?? ""
				
				// in the event that we may change the deployment, we need to be able to update this in only one place
				if apiDomain != apiString {
					UserDefaults.standard.set(apiString, forKey: apiCacheKey)
					UserDefaults.standard.synchronize()
				}
			}
		}
		else {
			
			// not in the cache, look in .plist
			if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
				nsDictionary = NSDictionary(contentsOfFile: path)
				
				apiDomain = nsDictionary?[apiCacheKey] as? String ?? ""
				UserDefaults.standard.set(apiDomain, forKey: apiCacheKey)
				UserDefaults.standard.synchronize()
			}
			else {
				// file not found
				fatalError("Local Config.plist not found. Please ensure your project includes this on the top level.")
			}
		}
		
		if apiDomain == "nil" {
			// something went wrong here, and we aren't sure where the API is
			fatalError("API Address could not be determined.")
		}
	}
}
