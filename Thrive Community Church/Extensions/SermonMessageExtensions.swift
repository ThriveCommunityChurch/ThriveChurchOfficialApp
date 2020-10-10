//
//  SermonMessageCollectionExtensions.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 4/25/20.
//  Copyright © 2020 Thrive Community Church. All rights reserved.
//

import Foundation
import UIKit

extension SermonMessage {
	
	public func registerDataForRecentlyPlayed(seriesImage: UIImage? = nil) {
		
		// reset the data
		var recentlyPlayed: [SermonMessage] = [SermonMessage]()
		
		// get the recently played sermon messages
		let decoded = UserDefaults.standard.object(forKey: ApplicationVariables.RecentlyPlayed) as? Data
		if decoded != nil {
			
			recentlyPlayed = NSKeyedUnarchiver.unarchiveObject(with: decoded ?? Data()) as! [SermonMessage]
			let count = recentlyPlayed.count
			
			// the Id index of the sermons here are in the same order
			let idArray = getUniqueIDsFromArrayOfObjects(events: recentlyPlayed)
			
			// if this list already contains the message, and its the only one
			// just return because we won't be doing anything new
			if count == 1 && idArray.contains(self.MessageId) {
				return
			}
			
			// set the timestamp for this message using ms since epoch
			self.previouslyPlayed = NSTimeIntervalSince1970
			
			// set the image from the above series if it hasn't already been set
			if self.seriesArt == nil {
				self.seriesArt = seriesImage?.pngData()
			}
			
			print("PREVIOUS \(recentlyPlayed.count)")
			
			// if we have 9 or less, then we should register this one, because we will have 10
			// if we always insert at 0 we'll always have the most recent at the top
			if count <= 9 {
				recentlyPlayed = removeMatchingMessages(recentlyPlayed: recentlyPlayed)
				
				print("AFTER REMOVAL \(recentlyPlayed.count)")
				
				recentlyPlayed.insert(self, at: 0)
				
				print("AFTER INSERT \(recentlyPlayed.count)")
			}
			else {
				
				// we need to move the one we have, so delete it wherever it's at
				recentlyPlayed = self.removeMatchingMessages(recentlyPlayed: recentlyPlayed)
				
				// THEN we can insert at 0 and pop the one on the end
				recentlyPlayed.remove(at: recentlyPlayed.count - 1)
				recentlyPlayed.insert(self, at: 0)
			}
		}
		else {
			// we haven't found anything in UD so add something
			self.previouslyPlayed = NSTimeIntervalSince1970
			
			// set the image from the above series if it hasn't already been set
			if self.seriesArt == nil {
				self.seriesArt = seriesImage?.pngData()
			}
			
			recentlyPlayed.insert(self, at: 0)
		}
		
		print("LAST \(recentlyPlayed.count)")
		
		// before we can place objects into Defaults they have to be encoded
		let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: recentlyPlayed)
		
		// we have a reference to this message in the above Defaults array, so store everything
		UserDefaults.standard.set(encodedData, forKey: ApplicationVariables.RecentlyPlayed)
		UserDefaults.standard.synchronize()
	}
	
	private func removeMatchingMessages(recentlyPlayed: [SermonMessage]) -> [SermonMessage] {
		
		// we can't mutate the param because its a let constant
		var recents = recentlyPlayed
		
		// the Id index of the sermons here are in the same order
		let idArray = getUniqueIDsFromArrayOfObjects(events: recents)
		
		if idArray.contains(self.MessageId) {
			// remove all instances of the message we are playing
			recents.removeAll(where: { (sermonMessage) -> Bool in
				sermonMessage.MessageId == self.MessageId
			})
		}
		
		return recents
	}
	
	private func getUniqueIDsFromArrayOfObjects(events: [SermonMessage]) -> [String] {
		let eventIds = events.map { $0.MessageId}
		let idset = Set(eventIds)
		return Array(idset)
	}
}
