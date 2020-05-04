//
//  SermonMessageCollectionExtensions.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 4/25/20.
//  Copyright © 2020 Thrive Community Church. All rights reserved.
//

import Foundation

extension SermonMessage {
	
	public func registerDataForRecentlyPlayed() {
		
		// reset the data
		var recentlyPlayed = [SermonMessage]()
		
		// get the recently played sermon messages
		let decoded = UserDefaults.standard.object(forKey: ApplicationVariables.RecentlyPlayed) as? Data
		if decoded != nil {
			
			let decodedSermonMessages = NSKeyedUnarchiver.unarchiveObject(with: decoded ?? Data()) as! [SermonMessage]
			
			var count = decodedSermonMessages.count
			recentlyPlayed = decodedSermonMessages
			
			// set the timestamp for this message using ms since epoch
			self.previouslyPlayed = NSTimeIntervalSince1970
			
			// if we have 9 or less, then we should register this one, because we will have 10
			// if we always insert at 0 we'll always have the most recent at the top
			if count <= 9 {
				count = removeMatchingMessages(recentlyPlayed: recentlyPlayed)
				recentlyPlayed.insert(self, at: 0)
			}
			else {
				
				// we need to move the one we have, so delete it wherever it's at
				count = self.removeMatchingMessages(recentlyPlayed: recentlyPlayed)
				
				// THEN we can insert at 0 and pop the one on the end
				recentlyPlayed.remove(at: count - 1)
				recentlyPlayed.insert(self, at: 0)
			}
		}
		else {
			// we haven't found anything in UD so add something
			self.previouslyPlayed = NSTimeIntervalSince1970
			recentlyPlayed.insert(self, at: 0)
		}
		
		// before we can place objects into Defaults they have to be encoded
		let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: recentlyPlayed)
		
		// we have a reference to this message in the above Defaults array, so store everything
		UserDefaults.standard.set(encodedData, forKey: ApplicationVariables.RecentlyPlayed)
		UserDefaults.standard.synchronize()
	}
	
	private func removeMatchingMessages(recentlyPlayed: [SermonMessage]) -> Int {
		
		var recents = recentlyPlayed
		
		// the Id index of the sermons here are in the same order
		let idArray = getUniqueIDsFromArrayOfObjects(events: recents)
		
		if idArray.contains(self.MessageId) {
			// remove all instances of the message we are playing
			recents.removeAll(where: { (sermonMessage) -> Bool in
				sermonMessage.MessageId == self.MessageId
			})
		}
		
		return recents.count
	}
	
	private func getUniqueIDsFromArrayOfObjects(events: [SermonMessage]) -> [String] {
		let eventIds = events.map { $0.MessageId}
		let idset = Set(eventIds)
		return Array(idset)
	}
}
