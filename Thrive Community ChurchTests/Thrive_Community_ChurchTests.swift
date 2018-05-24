//
//  Thrive_Community_ChurchTests.swift
//  Thrive Community ChurchTests
//
//  Created by Wyatt Baggett on 5/22/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import XCTest
import UIKit

@testable import Thrive_Church_Official_App

var masterView: MasterViewController!
var detailView: DetailViewController!
var listenVC: SermonsViewController!

class ThriveChurchOfficialAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		
		masterView = MasterViewController()
		detailView = DetailViewController()
		listenVC = SermonsViewController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
		
		masterView = nil
		detailView = nil
		listenVC = nil
    }
	
	/// Assuming that some text was entered, save the note
    func testNoteCreated() {

		masterView.insertNewObject(self)

		
    }
	
	
}
