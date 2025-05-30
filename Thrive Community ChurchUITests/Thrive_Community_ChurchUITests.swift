//
//  Thrive_Community_ChurchUITests.swift
//  Thrive Community ChurchUITests
//
//  Created by Wyatt Baggett on 5/22/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import XCTest

class Thrive_Community_ChurchUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAppLaunchAndTabBarVisibility() {
        // Test basic app launch and tab bar setup
        let tabBar = app.tabBars.firstMatch
        let timeout = ProcessInfo.processInfo.environment["CI"] != nil ? 30.0 : 10.0
        XCTAssertTrue(waitForElementToAppear(tabBar, timeout: timeout), "Tab bar should be visible")

        // Validate all expected tabs exist
        let expectedTabs = ["Listen", "Notes", "Connect", "More"]
        for tabName in expectedTabs {
            let tab = tabBar.buttons[tabName]
            XCTAssertTrue(tab.exists, "Tab '\(tabName)' should exist")
        }

        takeScreenshot(name: "app_launch")
    }

    func testAllTabsAccessible() {
        let tabs = ["Listen", "Notes", "Connect", "More"]
        let timeout = ProcessInfo.processInfo.environment["CI"] != nil ? 15.0 : 5.0
        let sleepInterval = ProcessInfo.processInfo.environment["CI"] != nil ? 2.0 : 0.5

        for tab in tabs {
            let tabBar = app.tabBars.firstMatch
            let tabButton = tabBar.buttons[tab]
            tabButton.tap()

            // Wait for navigation to complete (longer in CI)
            Thread.sleep(forTimeInterval: sleepInterval)

            // Verify navigation title appears
            let navigationBar = app.navigationBars.firstMatch
            XCTAssertTrue(waitForElementToAppear(navigationBar, timeout: timeout),
                "Navigation bar should appear for \(tab) tab")

            takeScreenshot(name: "\(tab.lowercased())_tab")
        }
    }

    // Helper methods
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        return result == .completed
    }

    func takeScreenshot(name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

}
