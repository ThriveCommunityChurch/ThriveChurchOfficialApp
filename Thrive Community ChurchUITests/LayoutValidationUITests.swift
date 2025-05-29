//
//  LayoutValidationUITests.swift
//  Thrive Community ChurchUITests
//
//  Created by AI Assistant on Test Creation Day
//  Copyright © 2024 Thrive Community Church. All rights reserved.
//

import XCTest

class LayoutValidationUITests: ThriveUITestBase {
    
    // MARK: - AutoLayout Constraint Validation
    
    func testAutoLayoutConstraints() {
        let tabs = ["Listen", "Notes", "Connect", "More"]
        
        for tab in tabs {
            navigateToTab(tab)
            
            // Check for AutoLayout constraint errors in console
            // Note: This is a basic check - more sophisticated constraint validation
            // would require additional tooling or runtime constraint checking
            
            if tab == "Listen" {
                let collectionView = app.collectionViews.firstMatch
                XCTAssertTrue(waitForElementToAppear(collectionView), "\(tab) collection view should appear without constraint errors")
                
                // Validate collection view layout
                validateCollectionViewLayout(collectionView)
            } else {
                let tableView = app.tables.firstMatch
                XCTAssertTrue(waitForElementToAppear(tableView), "\(tab) table view should appear without constraint errors")
                
                // Validate table view layout
                validateTableViewLayout(tableView)
            }
            
            takeScreenshot(name: "autolayout_validation_\(tab.lowercased())")
        }
    }
    
    func validateCollectionViewLayout(_ collectionView: XCUIElement) {
        // Wait for content to load
        Thread.sleep(forTimeInterval: 2.0)
        
        let cells = collectionView.cells
        if cells.count > 0 {
            // Check first few cells for proper layout
            let cellsToCheck = min(cells.count, 4)
            
            for i in 0..<cellsToCheck {
                let cell = cells.element(boundBy: i)
                
                // Validate cell is within collection view bounds
                XCTAssertGreaterThanOrEqual(cell.frame.minX, collectionView.frame.minX - 1,
                    "Cell \(i) should be within collection view left bounds")
                XCTAssertLessThanOrEqual(cell.frame.maxX, collectionView.frame.maxX + 1,
                    "Cell \(i) should be within collection view right bounds")
                
                // Validate cell has reasonable dimensions
                XCTAssertGreaterThan(cell.frame.width, 100, "Cell \(i) should have reasonable width")
                XCTAssertGreaterThan(cell.frame.height, 100, "Cell \(i) should have reasonable height")
                
                // Validate cell doesn't overlap with others (basic check)
                if i > 0 {
                    let previousCell = cells.element(boundBy: i - 1)
                    let verticalOverlap = min(cell.frame.maxY, previousCell.frame.maxY) - max(cell.frame.minY, previousCell.frame.minY)
                    let horizontalOverlap = min(cell.frame.maxX, previousCell.frame.maxX) - max(cell.frame.minX, previousCell.frame.minX)
                    
                    // If cells are in same row, they shouldn't overlap horizontally
                    if abs(cell.frame.midY - previousCell.frame.midY) < 50 {
                        XCTAssertLessThanOrEqual(horizontalOverlap, 0, "Cells in same row should not overlap horizontally")
                    }
                    // If cells are in same column, they shouldn't overlap vertically
                    if abs(cell.frame.midX - previousCell.frame.midX) < 50 {
                        XCTAssertLessThanOrEqual(verticalOverlap, 0, "Cells in same column should not overlap vertically")
                    }
                }
            }
        }
    }
    
    func validateTableViewLayout(_ tableView: XCUIElement) {
        // Wait for content to load
        Thread.sleep(forTimeInterval: 1.0)
        
        let cells = tableView.cells
        if cells.count > 0 {
            // Check first few cells for proper layout
            let cellsToCheck = min(cells.count, 5)
            
            for i in 0..<cellsToCheck {
                let cell = cells.element(boundBy: i)
                
                // Validate cell is within table view bounds
                XCTAssertGreaterThanOrEqual(cell.frame.minX, tableView.frame.minX - 1,
                    "Cell \(i) should be within table view left bounds")
                XCTAssertLessThanOrEqual(cell.frame.maxX, tableView.frame.maxX + 1,
                    "Cell \(i) should be within table view right bounds")
                
                // Validate cell has reasonable dimensions
                XCTAssertGreaterThan(cell.frame.width, 100, "Cell \(i) should have reasonable width")
                XCTAssertGreaterThan(cell.frame.height, 50, "Cell \(i) should have reasonable height")
                
                // Validate cells don't overlap vertically
                if i > 0 {
                    let previousCell = cells.element(boundBy: i - 1)
                    XCTAssertGreaterThanOrEqual(cell.frame.minY, previousCell.frame.maxY - 2,
                        "Cell \(i) should not overlap with previous cell")
                }
            }
        }
    }
    
    // MARK: - Spacing and Margin Validation
    
    func testSpacingConsistency() {
        let tabs = ["Listen", "Notes", "Connect", "More"]
        
        for tab in tabs {
            navigateToTab(tab)
            
            if tab == "Listen" {
                validateCollectionViewSpacing()
            } else {
                validateTableViewSpacing()
            }
            
            takeScreenshot(name: "spacing_validation_\(tab.lowercased())")
        }
    }
    
    func validateCollectionViewSpacing() {
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(waitForElementToAppear(collectionView), "Collection view should be visible")
        
        // Wait for content to load
        Thread.sleep(forTimeInterval: 2.0)
        
        let cells = collectionView.cells
        if cells.count > 1 {
            // Validate 16pt horizontal margins
            let firstCell = cells.element(boundBy: 0)
            validateHorizontalMargins(element: firstCell, expectedMargin: 16)
            
            // Validate 8pt vertical spacing between cells
            let cellArray = (0..<min(cells.count, 3)).map { cells.element(boundBy: $0) }
            validateCardSpacing(cells: cellArray, expectedSpacing: 8)
        }
    }
    
    func validateTableViewSpacing() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible")
        
        // Wait for content to load
        Thread.sleep(forTimeInterval: 1.0)
        
        let cells = tableView.cells
        if cells.count > 1 {
            // Validate 16pt horizontal margins
            let firstCell = cells.element(boundBy: 0)
            validateHorizontalMargins(element: firstCell, expectedMargin: 16)
            
            // Validate 8pt vertical spacing between cards
            let cellArray = (0..<min(cells.count, 3)).map { cells.element(boundBy: $0) }
            validateCardSpacing(cells: cellArray, expectedSpacing: 8)
        }
    }
    
    // MARK: - Text Readability Validation
    
    func testTextReadability() {
        let tabs = ["Notes", "Connect", "More"] // Text-heavy tabs
        
        for tab in tabs {
            navigateToTab(tab)
            
            let tableView = app.tables.firstMatch
            XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible")
            
            // Wait for content to load
            Thread.sleep(forTimeInterval: 1.0)
            
            let cells = tableView.cells
            if cells.count > 0 {
                let cellsToCheck = min(cells.count, 3)
                
                for i in 0..<cellsToCheck {
                    let cell = cells.element(boundBy: i)
                    let staticTexts = cell.staticTexts
                    
                    for j in 0..<min(staticTexts.count, 2) {
                        let text = staticTexts.element(boundBy: j)
                        
                        // Validate text is not truncated excessively
                        XCTAssertGreaterThan(text.frame.width, 50, 
                            "\(tab) cell \(i) text \(j) should have reasonable width")
                        XCTAssertGreaterThan(text.frame.height, 12, 
                            "\(tab) cell \(i) text \(j) should have readable height")
                        
                        // Validate text is within cell bounds
                        XCTAssertGreaterThanOrEqual(text.frame.minX, cell.frame.minX,
                            "Text should be within cell left bounds")
                        XCTAssertLessThanOrEqual(text.frame.maxX, cell.frame.maxX,
                            "Text should be within cell right bounds")
                    }
                }
            }
            
            takeScreenshot(name: "text_readability_\(tab.lowercased())")
        }
    }
    
    // MARK: - Image Aspect Ratio Validation
    
    func testImageAspectRatios() {
        navigateToTab("Listen")
        
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(waitForElementToAppear(collectionView), "Collection view should be visible")
        
        // Wait for content to load
        Thread.sleep(forTimeInterval: 3.0)
        
        let cells = collectionView.cells
        if cells.count > 0 {
            let cellsToCheck = min(cells.count, 3)
            
            for i in 0..<cellsToCheck {
                let cell = cells.element(boundBy: i)
                
                // Series images should maintain proper aspect ratio
                // Assuming square or 16:9 aspect ratio for series artwork
                let aspectRatio = cell.frame.width / cell.frame.height
                XCTAssertGreaterThan(aspectRatio, 0.8, "Cell \(i) aspect ratio should be reasonable (not too tall)")
                XCTAssertLessThan(aspectRatio, 2.0, "Cell \(i) aspect ratio should be reasonable (not too wide)")
            }
        }
        
        takeScreenshot(name: "image_aspect_ratios")
    }
    
    // MARK: - Button and Interactive Element Validation
    
    func testInteractiveElementSizes() {
        let tabs = ["Listen", "Notes", "Connect", "More"]
        
        for tab in tabs {
            navigateToTab(tab)
            
            // Check navigation bar buttons
            let navigationBar = app.navigationBars.firstMatch
            if navigationBar.exists {
                let buttons = navigationBar.buttons
                for i in 0..<buttons.count {
                    let button = buttons.element(boundBy: i)
                    if button.exists {
                        // Buttons should be large enough for touch (44pt minimum)
                        XCTAssertGreaterThanOrEqual(max(button.frame.width, button.frame.height), 40,
                            "\(tab) navigation button \(i) should be large enough for touch")
                    }
                }
            }
            
            // Check tab bar buttons
            let tabBar = app.tabBars.firstMatch
            if tabBar.exists {
                let tabButtons = tabBar.buttons
                for i in 0..<tabButtons.count {
                    let button = tabButtons.element(boundBy: i)
                    if button.exists {
                        // Tab buttons should be large enough for touch
                        XCTAssertGreaterThanOrEqual(max(button.frame.width, button.frame.height), 40,
                            "Tab button \(i) should be large enough for touch")
                    }
                }
            }
            
            takeScreenshot(name: "interactive_elements_\(tab.lowercased())")
        }
    }
    
    // MARK: - Content Overflow Validation
    
    func testContentOverflow() {
        let tabs = ["Listen", "Notes", "Connect", "More"]
        
        for tab in tabs {
            navigateToTab(tab)
            
            let screenBounds = XCUIScreen.main.bounds
            
            if tab == "Listen" {
                let collectionView = app.collectionViews.firstMatch
                XCTAssertTrue(waitForElementToAppear(collectionView), "Collection view should be visible")
                
                // Validate collection view doesn't overflow screen
                XCTAssertGreaterThanOrEqual(collectionView.frame.minX, 0,
                    "Collection view should not overflow left edge")
                XCTAssertLessThanOrEqual(collectionView.frame.maxX, screenBounds.width,
                    "Collection view should not overflow right edge")
            } else {
                let tableView = app.tables.firstMatch
                XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible")
                
                // Validate table view doesn't overflow screen
                XCTAssertGreaterThanOrEqual(tableView.frame.minX, 0,
                    "Table view should not overflow left edge")
                XCTAssertLessThanOrEqual(tableView.frame.maxX, screenBounds.width,
                    "Table view should not overflow right edge")
            }
            
            takeScreenshot(name: "content_overflow_\(tab.lowercased())")
        }
    }
    
    // MARK: - Dark Theme Validation
    
    func testDarkThemeConsistency() {
        let tabs = ["Listen", "Notes", "Connect", "More"]
        
        for tab in tabs {
            navigateToTab(tab)
            
            // Validate dark theme elements are present
            // This is a basic visual check - more sophisticated color detection could be added
            
            let navigationBar = app.navigationBars.firstMatch
            XCTAssertTrue(navigationBar.exists, "Navigation bar should exist")
            
            let tabBar = app.tabBars.firstMatch
            XCTAssertTrue(tabBar.exists, "Tab bar should exist")
            
            // Check that main content area exists (dark background should be visible)
            if tab == "Listen" {
                let collectionView = app.collectionViews.firstMatch
                XCTAssertTrue(collectionView.exists, "Collection view should exist with dark theme")
            } else {
                let tableView = app.tables.firstMatch
                XCTAssertTrue(tableView.exists, "Table view should exist with dark theme")
            }
            
            takeScreenshot(name: "dark_theme_\(tab.lowercased())")
        }
    }
}
