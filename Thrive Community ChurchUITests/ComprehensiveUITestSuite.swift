//
//  ComprehensiveUITestSuite.swift
//  Thrive Community ChurchUITests
//
//  Created by AI Assistant on Test Creation Day
//  Copyright © 2024 Thrive Community Church. All rights reserved.
//

import XCTest

class ComprehensiveUITestSuite: ThriveUITestBase {
    
    // MARK: - Comprehensive Test Suite Runner
    
    func testCompleteAppUIValidation() {
        // This test runs a comprehensive validation of the entire app UI
        // across different device sizes and orientations
        
        let deviceType = isIPad ? "iPad" : "iPhone"
        print("Running comprehensive UI test suite on \(deviceType)")
        
        // Test basic app launch and navigation
        testAppLaunchAndBasicNavigation()
        
        // Test all tabs in both orientations
        testAllTabsInBothOrientations()
        
        // Test device-specific features
        if isIPad {
            testIPadSpecificFeatures()
        } else {
            testIPhoneSpecificFeatures()
        }
        
        // Test layout validation
        testLayoutValidationAcrossAllTabs()
        
        // Test interaction flows
        testKeyInteractionFlows()
        
        print("Comprehensive UI test suite completed successfully")
    }
    
    // MARK: - Basic App Validation
    
    func testAppLaunchAndBasicNavigation() {
        // Validate app launches successfully
        XCTAssertTrue(app.state == .runningForeground, "App should be running in foreground")
        
        // Validate tab bar is visible and functional
        validateTabBarAppearance()
        
        // Test navigation to each tab
        let tabs = ["Listen", "Notes", "Connect", "More"]
        for tab in tabs {
            navigateToTab(tab)
            validateNavigationBarAppearance(expectedTitle: tab)
        }
        
        takeScreenshot(name: "app_launch_validation")
    }
    
    func testAllTabsInBothOrientations() {
        let tabs = ["Listen", "Notes", "Connect", "More"]
        
        // Test in portrait
        rotateToPortrait()
        for tab in tabs {
            navigateToTab(tab)
            validateTabLayout(tab, orientation: "portrait")
        }
        
        // Test in landscape
        rotateToLandscape()
        for tab in tabs {
            navigateToTab(tab)
            validateTabLayout(tab, orientation: "landscape")
        }
        
        // Return to portrait
        rotateToPortrait()
    }
    
    func validateTabLayout(_ tabName: String, orientation: String) {
        if tabName == "Listen" {
            let collectionView = app.collectionViews.firstMatch
            XCTAssertTrue(waitForElementToAppear(collectionView), 
                "\(tabName) collection view should be visible in \(orientation)")
            validateNoWhiteSpace(in: collectionView, 
                description: "\(tabName) collection view in \(orientation)")
        } else {
            let tableView = app.tables.firstMatch
            XCTAssertTrue(waitForElementToAppear(tableView), 
                "\(tabName) table view should be visible in \(orientation)")
            validateNoWhiteSpace(in: tableView, 
                description: "\(tabName) table view in \(orientation)")
        }
        
        if isIPad {
            validateNoWhiteBars()
        }
        
        takeScreenshot(name: "\(tabName.lowercased())_\(orientation)_validation")
    }
    
    // MARK: - Device-Specific Tests
    
    func testIPadSpecificFeatures() {
        // Test adaptive layout constraints
        let tabs = ["Listen", "Notes", "Connect", "More"]
        for tab in tabs {
            navigateToTab(tab)
            
            if tab == "Listen" {
                let collectionView = app.collectionViews.firstMatch
                Thread.sleep(forTimeInterval: 1.0)
                let cells = collectionView.cells
                if cells.count > 0 {
                    let firstCell = cells.element(boundBy: 0)
                    validateIPadAdaptiveLayout(element: firstCell)
                }
            } else {
                let tableView = app.tables.firstMatch
                Thread.sleep(forTimeInterval: 1.0)
                let cells = tableView.cells
                if cells.count > 0 {
                    let firstCell = cells.element(boundBy: 0)
                    validateIPadAdaptiveLayout(element: firstCell)
                }
            }
        }
        
        // Test multi-column layout in landscape
        rotateToLandscape()
        navigateToTab("Listen")
        
        let collectionView = app.collectionViews.firstMatch
        Thread.sleep(forTimeInterval: 1.0)
        let cells = collectionView.cells
        if cells.count > 1 {
            let firstCell = cells.element(boundBy: 0)
            let secondCell = cells.element(boundBy: 1)
            
            // Check for side-by-side layout
            let horizontalSpacing = abs(firstCell.frame.midY - secondCell.frame.midY)
            if horizontalSpacing < 50 {
                XCTAssertLessThan(firstCell.frame.maxX, secondCell.frame.minX,
                    "iPad landscape should show multi-column layout")
            }
        }
        
        rotateToPortrait()
        takeScreenshot(name: "ipad_specific_features_validation")
    }
    
    func testIPhoneSpecificFeatures() {
        // Test single-column layout
        let tabs = ["Listen", "Notes", "Connect", "More"]
        for tab in tabs {
            navigateToTab(tab)
            
            if tab == "Listen" {
                let collectionView = app.collectionViews.firstMatch
                Thread.sleep(forTimeInterval: 1.0)
                let cells = collectionView.cells
                
                // iPhone should typically show single column
                if cells.count > 1 {
                    let firstCell = cells.element(boundBy: 0)
                    let secondCell = cells.element(boundBy: 1)
                    
                    // Check for vertical stacking
                    let verticalSpacing = abs(firstCell.frame.midX - secondCell.frame.midX)
                    if verticalSpacing < 50 {
                        XCTAssertLessThan(firstCell.frame.maxY, secondCell.frame.minY + 50,
                            "iPhone should show vertical stacking")
                    }
                }
            }
        }
        
        takeScreenshot(name: "iphone_specific_features_validation")
    }
    
    // MARK: - Layout Validation
    
    func testLayoutValidationAcrossAllTabs() {
        let tabs = ["Listen", "Notes", "Connect", "More"]
        
        for tab in tabs {
            navigateToTab(tab)
            
            // Validate spacing and margins
            if tab == "Listen" {
                let collectionView = app.collectionViews.firstMatch
                Thread.sleep(forTimeInterval: 1.0)
                let cells = collectionView.cells
                if cells.count > 0 {
                    let firstCell = cells.element(boundBy: 0)
                    validateHorizontalMargins(element: firstCell, expectedMargin: 16)
                    
                    if cells.count > 1 {
                        let cellArray = (0..<min(cells.count, 3)).map { cells.element(boundBy: $0) }
                        validateCardSpacing(cells: cellArray, expectedSpacing: 8)
                    }
                }
            } else {
                let tableView = app.tables.firstMatch
                Thread.sleep(forTimeInterval: 1.0)
                let cells = tableView.cells
                if cells.count > 0 {
                    let firstCell = cells.element(boundBy: 0)
                    validateHorizontalMargins(element: firstCell, expectedMargin: 16)
                    
                    if cells.count > 1 {
                        let cellArray = (0..<min(cells.count, 3)).map { cells.element(boundBy: $0) }
                        validateCardSpacing(cells: cellArray, expectedSpacing: 8)
                    }
                }
            }
            
            // Validate modern card design (80pt height for table cells)
            if tab != "Listen" {
                let tableView = app.tables.firstMatch
                let cells = tableView.cells
                if cells.count > 0 {
                    let firstCell = cells.element(boundBy: 0)
                    let cellHeight = firstCell.frame.height
                    XCTAssertGreaterThanOrEqual(cellHeight, 75, 
                        "\(tab) cell height should be at least 75pt")
                    XCTAssertLessThanOrEqual(cellHeight, 85, 
                        "\(tab) cell height should not exceed 85pt")
                }
            }
        }
        
        takeScreenshot(name: "layout_validation_complete")
    }
    
    // MARK: - Key Interaction Flows
    
    func testKeyInteractionFlows() {
        // Test Listen tab interactions
        testListenTabInteractions()
        
        // Test Notes tab interactions
        testNotesTabInteractions()
        
        // Test Connect tab interactions
        testConnectTabInteractions()
        
        // Test More tab interactions
        testMoreTabInteractions()
    }
    
    func testListenTabInteractions() {
        navigateToTab("Listen")
        
        // Test Now Playing button
        let navigationBar = app.navigationBars.firstMatch
        let nowPlayingButton = navigationBar.buttons.matching(identifier: "playback").firstMatch
        if nowPlayingButton.exists {
            nowPlayingButton.tap()
            Thread.sleep(forTimeInterval: 1.0)
            
            let nowPlayingNav = app.navigationBars["Now Playing"]
            if nowPlayingNav.exists {
                takeScreenshot(name: "now_playing_interaction")
                let backButton = nowPlayingNav.buttons.element(boundBy: 0)
                if backButton.exists {
                    backButton.tap()
                    Thread.sleep(forTimeInterval: 0.5)
                }
            }
        }
        
        // Test collection view cell interaction
        let collectionView = app.collectionViews.firstMatch
        Thread.sleep(forTimeInterval: 2.0)
        let cells = collectionView.cells
        if cells.count > 0 {
            let firstCell = cells.element(boundBy: 0)
            firstCell.tap()
            Thread.sleep(forTimeInterval: 1.0)
            
            // Should navigate to series detail
            let navBar = app.navigationBars.firstMatch
            if navBar.exists {
                takeScreenshot(name: "series_detail_interaction")
                let backButton = navBar.buttons.element(boundBy: 0)
                if backButton.exists {
                    backButton.tap()
                    Thread.sleep(forTimeInterval: 0.5)
                }
            }
        }
    }
    
    func testNotesTabInteractions() {
        navigateToTab("Notes")
        
        // Test add note button
        let navigationBar = app.navigationBars.firstMatch
        let addButton = navigationBar.buttons["Add"]
        if addButton.exists {
            addButton.tap()
            Thread.sleep(forTimeInterval: 1.0)
            
            takeScreenshot(name: "add_note_interaction")
            
            let navBar = app.navigationBars.firstMatch
            let backButton = navBar.buttons.element(boundBy: 0)
            if backButton.exists {
                backButton.tap()
                Thread.sleep(forTimeInterval: 0.5)
            }
        }
    }
    
    func testConnectTabInteractions() {
        navigateToTab("Connect")
        
        // Test announcements navigation
        let tableView = app.tables.firstMatch
        Thread.sleep(forTimeInterval: 1.0)
        
        let announcementsCell = tableView.cells.staticTexts["Announcements"].firstMatch
        if announcementsCell.exists {
            let cell = announcementsCell.firstAncestor(withType: .cell)
            cell.tap()
            Thread.sleep(forTimeInterval: 2.0)
            
            let announcementsNav = app.navigationBars["Announcements"]
            if announcementsNav.exists {
                takeScreenshot(name: "announcements_interaction")
                let backButton = announcementsNav.buttons.element(boundBy: 0)
                if backButton.exists {
                    backButton.tap()
                    Thread.sleep(forTimeInterval: 0.5)
                }
            }
        }
    }
    
    func testMoreTabInteractions() {
        navigateToTab("More")
        
        // Test Bible navigation
        let tableView = app.tables.firstMatch
        Thread.sleep(forTimeInterval: 1.0)
        
        let bibleCell = tableView.cells.staticTexts["Bible"].firstMatch
        if bibleCell.exists {
            let cell = bibleCell.firstAncestor(withType: .cell)
            cell.tap()
            Thread.sleep(forTimeInterval: 2.0)
            
            let bibleNav = app.navigationBars["Bible"]
            if bibleNav.exists {
                takeScreenshot(name: "bible_interaction")
                let backButton = bibleNav.buttons.element(boundBy: 0)
                if backButton.exists {
                    backButton.tap()
                    Thread.sleep(forTimeInterval: 0.5)
                }
            }
        }
    }
    
    // MARK: - Performance and Responsiveness Tests
    
    func testScrollingPerformance() {
        let tabs = ["Listen", "Notes", "Connect", "More"]
        
        for tab in tabs {
            navigateToTab(tab)
            
            if tab == "Listen" {
                let collectionView = app.collectionViews.firstMatch
                Thread.sleep(forTimeInterval: 2.0)
                
                // Test smooth scrolling
                let startTime = Date()
                collectionView.swipeUp()
                collectionView.swipeUp()
                collectionView.swipeDown()
                collectionView.swipeDown()
                let endTime = Date()
                
                let scrollTime = endTime.timeIntervalSince(startTime)
                XCTAssertLessThan(scrollTime, 2.0, "\(tab) scrolling should be responsive")
            } else {
                let tableView = app.tables.firstMatch
                Thread.sleep(forTimeInterval: 1.0)
                
                // Test smooth scrolling
                let startTime = Date()
                tableView.swipeUp()
                tableView.swipeUp()
                tableView.swipeDown()
                tableView.swipeDown()
                let endTime = Date()
                
                let scrollTime = endTime.timeIntervalSince(startTime)
                XCTAssertLessThan(scrollTime, 2.0, "\(tab) scrolling should be responsive")
            }
        }
        
        takeScreenshot(name: "scrolling_performance_test")
    }
}
