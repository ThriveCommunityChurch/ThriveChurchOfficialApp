//
//  NSKeyedUnarchiverExtension.swift
//  Thrive Church Official App
//
//  Created by AI Assistant on Migration Day
//  Copyright © 2024 Thrive Community Church. All rights reserved.
//

import Foundation

extension NSKeyedUnarchiver {

    /// Safely unarchive a SermonMessage object with explicit allowed classes
    static func safelyUnarchiveSermonMessage(from data: Data) -> SermonMessage? {
        let allowedClasses = NSSet(array: [
            SermonMessage.self,
            NSString.self,
            NSNumber.self,
            NSData.self,
            NSDate.self,
            NSURL.self
        ])

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClasses: allowedClasses as! Set<AnyHashable>, from: data) as? SermonMessage
        } catch {
            return nil
        }
    }

    /// Safely unarchive an array of SermonMessage objects with explicit allowed classes
    static func safelyUnarchiveSermonMessageArray(from data: Data) -> [SermonMessage] {
        let allowedClasses = NSSet(array: [
            NSArray.self,
            SermonMessage.self,
            NSString.self,
            NSNumber.self,
            NSData.self,
            NSDate.self,
            NSURL.self
        ])

        do {
            if let array = try NSKeyedUnarchiver.unarchivedObject(ofClasses: allowedClasses as! Set<AnyHashable>, from: data) as? [SermonMessage] {
                return array
            } else {
                return [SermonMessage]()
            }
        } catch {
            return [SermonMessage]()
        }
    }

    /// Safely unarchive a ConfigSetting object with explicit allowed classes
    static func safelyUnarchiveConfigSetting(from data: Data) -> ConfigSetting? {
        let allowedClasses = NSSet(array: [
            ConfigSetting.self,
            NSString.self,
            NSNumber.self,
            NSData.self,
            NSDate.self
        ])

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClasses: allowedClasses as! Set<AnyHashable>, from: data) as? ConfigSetting
        } catch {
            return nil
        }
    }
}
