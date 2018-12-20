//
//  StaticVars.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/19/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import Foundation

class ApplicationVariables {
	/// Cache key for reading the ThriveChurchOfficialAPI domain address from plist and UserDefaults
	static var ApiCacheKey = "APIUrl"
	/// Cache key for reading whether or not a user completed onboarding
	static var OnboardingCacheKey = "onboarding"
	/// Cache key for reading the saved notes taken
	static var NotesCacheKey = "notes"
}
