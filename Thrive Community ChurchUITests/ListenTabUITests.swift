//
//  ListenTabUITests.swift
//  Thrive Community ChurchUITests
//
//  Created by AI Assistant on Test Creation Day
//  Copyright © 2024 Thrive Community Church. All rights reserved.
//

import XCTest

class ListenTabUITests: ThriveUITestBase {
    
    override func setUp() {
        super.setUp()
        navigateToTab("Listen")
    }
    
    // MARK: - Basic Layout Tests
    
    func testListenTabBasicLayout() {
        validateNavigationBarAppearance(expectedTitle: "Listen")
        
        // Verify collection view exists and is visible
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(waitForElementToAppear(collectionView), "Collection view should be visible")
        validateNoWhiteSpace(in: collectionView, description: "Listen collection view")
        
        takeScreenshot(name: "listen_tab_basic_layout")
    }
    
    func testNavigationBarButtons() {
        let navigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(waitForElementToAppear(navigationBar), "Navigation bar should be visible")
        
        // Check for Recently Played button
        let recentlyPlayedButton = navigationBar.buttons.matching(identifier: "RecentlyPlayed").firstMatch
        XCTAssertTrue(recentlyPlayedButton.exists, "Recently Played button should exist")
        
        // Check for Now Playing button (should always be visible)
        let nowPlayingButton = navigationBar.buttons.matching(identifier: "playback").firstMatch
        XCTAssertTrue(nowPlayingButton.exists, "Now Playing button should always be visible")
        
        takeScreenshot(name: "listen_navigation_buttons")
    }
    
    func testCollectionViewCells() {
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(waitForElementToAppear(collectionView), "Collection view should be visible")
        
        // Wait for content to load
        Thread.sleep(forTimeInterval: 2.0)
        
        let cells = collectionView.cells
        if cells.count > 0 {
            // Test first few cells
            let cellsToTest = min(cells.count, 3)
            for i in 0..<cellsToTest {
                let cell = cells.element(boundBy: i)
                validateNoWhiteSpace(in: cell, description: "Collection view cell \(i)")
                
                // Validate card design (rounded corners and shadows are visual, but we can check positioning)
                XCTAssertGreaterThan(cell.frame.width, 100, "Cell should have reasonable width")
                XCTAssertGreaterThan(cell.frame.height, 100, "Cell should have reasonable height")
            }
            
            // Validate spacing between cells
            if cells.count > 1 {
                let cellArray = (0..<min(cells.count, 3)).map { cells.element(boundBy: $0) }
                validateCardSpacing(cells: cellArray, expectedSpacing: 8)
            }
        }
        
        takeScreenshot(name: "listen_collection_cells")
    }
    
    func testHorizontalMargins() {
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(waitForElementToAppear(collectionView), "Collection view should be visible")
        
        // Wait for content to load
        Thread.sleep(forTimeInterval: 2.0)
        
        let cells = collectionView.cells
        if cells.count > 0 {
            let firstCell = cells.element(boundBy: 0)
            validateHorizontalMargins(element: firstCell, expectedMargin: 16)
        }
        
        takeScreenshot(name: "listen_horizontal_margins")
    }
    
    func testIPadAdaptiveLayout() {
        if isIPad {
            let collectionView = app.collectionViews.firstMatch
            XCTAssertTrue(waitForElementToAppear(collectionView), "Collection view should be visible")
            
            // Wait for content to load
            Thread.sleep(forTimeInterval: 2.0)
            
            let cells = collectionView.cells
            if cells.count > 0 {
                let firstCell = cells.element(boundBy: 0)
                validateIPadAdaptiveLayout(element: firstCell)
                
                // iPad should show multiple columns in landscape
                if isLandscape && cells.count > 1 {
                    let secondCell = cells.element(boundBy: 1)
                    // Check if cells are side by side (multi-column layout)
                    let horizontalSpacing = abs(firstCell.frame.midY - secondCell.frame.midY)
                    if horizontalSpacing < 50 { // Cells are roughly on same row
                        XCTAssertLessThan(firstCell.frame.maxX, secondCell.frame.minX, 
                            "iPad landscape should show multi-column layout")
                    }
                }
            }
            
            takeScreenshot(name: "listen_ipad_adaptive_layout")
        }
    }
    
    func testScrollingBehavior() {
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(waitForElementToAppear(collectionView), "Collection view should be visible")
        
        // Wait for content to load
        Thread.sleep(forTimeInterval: 2.0)
        
        let cells = collectionView.cells
        if cells.count > 2 {
            // Test scrolling
            let initialFirstCell = cells.element(boundBy: 0)
            let initialPosition = initialFirstCell.frame.minY
            
            // Scroll down
            collectionView.swipeUp()
            Thread.sleep(forTimeInterval: 0.5)
            
            // Verify content moved
            let newPosition = initialFirstCell.frame.minY
            XCTAssertLessThan(newPosition, initialPosition, "Content should scroll up when swiping up")
            
            takeScreenshot(name: "listen_after_scroll")
        }
    }
    
    func testCellInteraction() {
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(waitForElementToAppear(collectionView), "Collection view should be visible")
        
        // Wait for content to load
        Thread.sleep(forTimeInterval: 2.0)
        
        let cells = collectionView.cells
        if cells.count > 0 {
            let firstCell = cells.element(boundBy: 0)
            
            // Test cell tap (should navigate to series view)
            firstCell.tap()
            
            // Wait for navigation
            Thread.sleep(forTimeInterval: 1.0)
            
            // Should navigate to series detail view
            let navigationBar = app.navigationBars.firstMatch
            XCTAssertTrue(navigationBar.exists, "Should navigate to series detail")
            
            // Go back
            let backButton = navigationBar.buttons.element(boundBy: 0)
            if backButton.exists {
                backButton.tap()
                Thread.sleep(forTimeInterval: 0.5)
            }
            
            takeScreenshot(name: "listen_cell_interaction")
        }
    }
    
    func testNowPlayingButtonFunctionality() {
        let navigationBar = app.navigationBars.firstMatch
        let nowPlayingButton = navigationBar.buttons.matching(identifier: "playback").firstMatch
        
        if nowPlayingButton.exists {
            nowPlayingButton.tap()
            
            // Wait for navigation
            Thread.sleep(forTimeInterval: 1.0)
            
            // Should navigate to Now Playing view
            let nowPlayingNavigationBar = app.navigationBars["Now Playing"]
            XCTAssertTrue(nowPlayingNavigationBar.exists, "Should navigate to Now Playing view")
            
            takeScreenshot(name: "now_playing_view")
            
            // Go back
            let backButton = nowPlayingNavigationBar.buttons.element(boundBy: 0)
            if backButton.exists {
                backButton.tap()
                Thread.sleep(forTimeInterval: 0.5)
            }
        }
    }
    
    func testRecentlyPlayedButtonFunctionality() {
        let navigationBar = app.navigationBars.firstMatch
        let recentlyPlayedButton = navigationBar.buttons.matching(identifier: "RecentlyPlayed").firstMatch
        
        if recentlyPlayedButton.exists {
            recentlyPlayedButton.tap()
            
            // Wait for navigation
            Thread.sleep(forTimeInterval: 1.0)
            
            // Should navigate to Recently Played view
            let recentlyPlayedNavigationBar = app.navigationBars["Recently Played"]
            XCTAssertTrue(recentlyPlayedNavigationBar.exists, "Should navigate to Recently Played view")
            
            takeScreenshot(name: "recently_played_view")
            
            // Go back
            let backButton = recentlyPlayedNavigationBar.buttons.element(boundBy: 0)
            if backButton.exists {
                backButton.tap()
                Thread.sleep(forTimeInterval: 0.5)
            }
        }
    }
    
    func testNoWhiteBarsOnIPad() {
        if isIPad {
            validateNoWhiteBars()
            takeScreenshot(name: "listen_ipad_no_white_bars")
        }
    }
    
    // MARK: - Orientation Tests
    
    func testLandscapeLayout() {
        rotateToLandscape()
        
        // Re-validate layout in landscape
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(waitForElementToAppear(collectionView), "Collection view should be visible in landscape")
        validateNoWhiteSpace(in: collectionView, description: "Listen collection view in landscape")
        
        if isIPad {
            validateNoWhiteBars()
        }
        
        takeScreenshot(name: "listen_landscape_layout")
        
        // Rotate back to portrait
        rotateToPortrait()
    }
    
    func testPortraitLayout() {
        rotateToPortrait()
        
        // Re-validate layout in portrait
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(waitForElementToAppear(collectionView), "Collection view should be visible in portrait")
        validateNoWhiteSpace(in: collectionView, description: "Listen collection view in portrait")
        
        if isIPad {
            validateNoWhiteBars()
        }
        
        takeScreenshot(name: "listen_portrait_layout")
    }
}
