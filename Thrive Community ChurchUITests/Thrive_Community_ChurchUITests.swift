//
//  Thrive_Community_ChurchUITests.swift
//  Thrive Community ChurchUITests
//
//  Created by Wyatt Baggett on 5/22/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import XCTest
import UIKit

@testable import Thrive_Church_Official_App


//var listenVC: SermonsViewController!

class Thrive_Community_ChurchUITests: XCTestCase {
	
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
//		listenVC = SermonsViewController()
		
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//	func testTableViewText() {
//
//		let app = XCUIApplication()
//		app.tabBars.buttons["Notes"].tap()
//		app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element.tap()
//		app.navigationBars["Add Note"].buttons["Notes"].tap()
//
////		assert(<#T##condition: Bool##Bool#>)
//	}
//
//	func testWebViews() {
//
//		let webView: UIWebView = UIWebView()
//		webView.loadWebPage(url: "http://thrive-fl.org/teaching-series")
//		let html = webView.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")
//
//		let webView2: UIWebView = UIWebView()
//		listenVC.sermonView = webView2
//		listenVC.sermonView.loadWebPage(url: "http://thrive-fl.org/teaching-series")
//		let loadedPageHtml = listenVC.sermonView.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")
//
//		assert(html == loadedPageHtml)
//
//	}
	
//	func testNoteText() {
//		
//		let app = XCUIApplication()
//		app.tabBars.buttons["Notes"].tap()
//		
//		let notesButton = app.navigationBars["Add Note"].buttons["Notes"]
//		notesButton.tap()
//		app.navigationBars["Notes"].buttons["Add"].tap()
//		app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element.tap()
//		notesButton.tap()
//		
//		var objects: [String] = [String]()
//		
//		if let loadedData = UserDefaults.standard.array(forKey: "notes") as? [String] {
//			objects = loadedData
//		}
//		
//		
//		assert(objects[0] == "This is a test note")
//		
//	}
	
}
