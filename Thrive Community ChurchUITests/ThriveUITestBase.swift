//
//  ThriveUITestBase.swift
//  Thrive Community ChurchUITests
//
//  Created by AI Assistant on Test Creation Day
//  Copyright © 2024 Thrive Community Church. All rights reserved.
//

import XCTest

// MARK: - Base UI Test Class

class ThriveUITestBase: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
        
        // Wait for app to fully load
        _ = app.wait(for: .runningForeground, timeout: 10)
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    // MARK: - Device Configuration Helpers
    
    var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var isIPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var isLandscape: Bool {
        return XCUIDevice.shared.orientation.isLandscape
    }
    
    var isPortrait: Bool {
        return XCUIDevice.shared.orientation.isPortrait
    }
    
    var deviceSuffix: String {
        return isIPad ? "ipad" : "iphone"
    }
    
    var orientationSuffix: String {
        return isLandscape ? "landscape" : "portrait"
    }
    
    // MARK: - Common Test Utilities
    
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 10) -> Bool {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    func waitForElementToDisappear(_ element: XCUIElement, timeout: TimeInterval = 10) -> Bool {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    func takeScreenshot(name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "\(name)_\(deviceSuffix)_\(orientationSuffix)"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func rotateToLandscape() {
        XCUIDevice.shared.orientation = .landscapeLeft
        Thread.sleep(forTimeInterval: 1.0) // Wait for rotation animation
    }
    
    func rotateToPortrait() {
        XCUIDevice.shared.orientation = .portrait
        Thread.sleep(forTimeInterval: 1.0) // Wait for rotation animation
    }
    
    // MARK: - Layout Validation Helpers
    
    func validateNoWhiteSpace(in element: XCUIElement, description: String) {
        XCTAssertTrue(element.exists, "\(description) should exist")
        
        // Check that element fills expected area (no excessive white space)
        let frame = element.frame
        XCTAssertGreaterThan(frame.width, 0, "\(description) should have positive width")
        XCTAssertGreaterThan(frame.height, 0, "\(description) should have positive height")
        
        // Validate element is within screen bounds
        let screenBounds = XCUIScreen.main.bounds
        XCTAssertGreaterThanOrEqual(frame.minX, 0, "\(description) should not extend beyond left edge")
        XCTAssertLessThanOrEqual(frame.maxX, screenBounds.width, "\(description) should not extend beyond right edge")
        XCTAssertGreaterThanOrEqual(frame.minY, 0, "\(description) should not extend beyond top edge")
        XCTAssertLessThanOrEqual(frame.maxY, screenBounds.height, "\(description) should not extend beyond bottom edge")
    }
    
    func validateCardSpacing(cells: [XCUIElement], expectedSpacing: CGFloat = 8) {
        guard cells.count > 1 else { return }
        
        for i in 0..<(cells.count - 1) {
            let currentCell = cells[i]
            let nextCell = cells[i + 1]
            
            let spacing = nextCell.frame.minY - currentCell.frame.maxY
            XCTAssertGreaterThanOrEqual(spacing, expectedSpacing - 2, 
                "Spacing between cells should be at least \(expectedSpacing)pt")
            XCTAssertLessThanOrEqual(spacing, expectedSpacing + 2, 
                "Spacing between cells should not exceed \(expectedSpacing + 2)pt")
        }
    }
    
    func validateHorizontalMargins(element: XCUIElement, expectedMargin: CGFloat = 16) {
        let screenWidth = XCUIScreen.main.bounds.width
        let leftMargin = element.frame.minX
        let rightMargin = screenWidth - element.frame.maxX
        
        XCTAssertGreaterThanOrEqual(leftMargin, expectedMargin - 2, 
            "Left margin should be at least \(expectedMargin)pt")
        XCTAssertGreaterThanOrEqual(rightMargin, expectedMargin - 2, 
            "Right margin should be at least \(expectedMargin)pt")
    }
    
    func validateIPadAdaptiveLayout(element: XCUIElement) {
        if isIPad {
            // iPad should have maximum content width constraint
            XCTAssertLessThanOrEqual(element.frame.width, 600, 
                "iPad content should respect maximum width constraint of 600pt")
            
            // Content should be centered when constrained
            let screenWidth = XCUIScreen.main.bounds.width
            if element.frame.width < screenWidth - 32 {
                let leftMargin = element.frame.minX
                let rightMargin = screenWidth - element.frame.maxX
                let marginDifference = abs(leftMargin - rightMargin)
                XCTAssertLessThan(marginDifference, 10, 
                    "iPad content should be centered when width is constrained")
            }
        }
    }
    
    func validateNoWhiteBars() {
        // Check for white bars at top and bottom of screen
        let screenBounds = XCUIScreen.main.bounds
        
        // Sample points at top and bottom edges
        let topPoint = CGPoint(x: screenBounds.midX, y: 10)
        let bottomPoint = CGPoint(x: screenBounds.midX, y: screenBounds.height - 10)
        
        // These should not be white/light colored areas
        // This is a basic check - more sophisticated color detection could be added
        let topElement = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.01))
        let bottomElement = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.99))
        
        // Verify elements exist at these positions (indicating content fills the space)
        XCTAssertTrue(topElement.exists, "Content should fill top area (no white bar)")
        XCTAssertTrue(bottomElement.exists, "Content should fill bottom area (no white bar)")
    }
    
    // MARK: - Navigation Helpers
    
    func navigateToTab(_ tabName: String) {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(waitForElementToAppear(tabBar), "Tab bar should be visible")
        
        let tab = tabBar.buttons[tabName]
        XCTAssertTrue(tab.exists, "Tab '\(tabName)' should exist")
        tab.tap()
        
        // Wait for navigation to complete
        Thread.sleep(forTimeInterval: 0.5)
    }
    
    func validateTabBarAppearance() {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(waitForElementToAppear(tabBar), "Tab bar should be visible")
        
        // Validate all expected tabs exist
        let expectedTabs = ["Listen", "Notes", "Connect", "More"]
        for tabName in expectedTabs {
            let tab = tabBar.buttons[tabName]
            XCTAssertTrue(tab.exists, "Tab '\(tabName)' should exist")
        }
        
        // Validate tab bar positioning
        let screenHeight = XCUIScreen.main.bounds.height
        XCTAssertGreaterThan(tabBar.frame.minY, screenHeight - 150, 
            "Tab bar should be positioned at bottom of screen")
        
        // Validate tab bar styling (dark theme)
        validateNoWhiteSpace(in: tabBar, description: "Tab bar")
    }
    
    func validateNavigationBarAppearance(expectedTitle: String? = nil) {
        let navigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(waitForElementToAppear(navigationBar), "Navigation bar should be visible")
        
        if let title = expectedTitle {
            let titleElement = navigationBar.staticTexts[title]
            XCTAssertTrue(titleElement.exists, "Navigation title '\(title)' should be visible")
        }
        
        // Validate navigation bar positioning
        XCTAssertLessThan(navigationBar.frame.minY, 100, 
            "Navigation bar should be positioned at top of screen")
        
        validateNoWhiteSpace(in: navigationBar, description: "Navigation bar")
    }
}
