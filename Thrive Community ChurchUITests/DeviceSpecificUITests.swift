//
//  DeviceSpecificUITests.swift
//  Thrive Community ChurchUITests
//
//  Created by AI Assistant on Test Creation Day
//  Copyright © 2024 Thrive Community Church. All rights reserved.
//

import XCTest

class DeviceSpecificUITests: ThriveUITestBase {

    // MARK: - iPhone Specific Tests

    func testIPhonePortraitLayout() {
        if isIPhone {
            rotateToPortrait()

            // Test all tabs in iPhone portrait
            let tabs = ["Listen", "Notes", "Connect", "More"]

            for tab in tabs {
                navigateToTab(tab)

                // Validate basic layout
                validateNavigationBarAppearance(expectedTitle: tab)
                validateTabBarAppearance()

                // Check main content area
                if tab == "Listen" {
                    let collectionView = app.collectionViews.firstMatch
                    XCTAssertTrue(waitForElementToAppear(collectionView), "\(tab) collection view should be visible")
                    validateNoWhiteSpace(in: collectionView, description: "\(tab) collection view")
                } else {
                    let tableView = app.tables.firstMatch
                    XCTAssertTrue(waitForElementToAppear(tableView), "\(tab) table view should be visible")
                    validateNoWhiteSpace(in: tableView, description: "\(tab) table view")
                }

                takeScreenshot(name: "iphone_portrait_\(tab.lowercased())")
            }
        }
    }

    func testIPhoneLandscapeLayout() {
        if isIPhone {
            rotateToLandscape()

            // Test all tabs in iPhone landscape
            let tabs = ["Listen", "Notes", "Connect", "More"]

            for tab in tabs {
                navigateToTab(tab)

                // Validate basic layout
                validateNavigationBarAppearance(expectedTitle: tab)
                validateTabBarAppearance()

                // Check main content area
                if tab == "Listen" {
                    let collectionView = app.collectionViews.firstMatch
                    XCTAssertTrue(waitForElementToAppear(collectionView), "\(tab) collection view should be visible")
                    validateNoWhiteSpace(in: collectionView, description: "\(tab) collection view")
                } else {
                    let tableView = app.tables.firstMatch
                    XCTAssertTrue(waitForElementToAppear(tableView), "\(tab) table view should be visible")
                    validateNoWhiteSpace(in: tableView, description: "\(tab) table view")
                }

                takeScreenshot(name: "iphone_landscape_\(tab.lowercased())")
            }

            // Rotate back to portrait
            rotateToPortrait()
        }
    }

    // MARK: - iPad Specific Tests

    func testIPadPortraitLayout() {
        if isIPad {
            rotateToPortrait()

            // Test all tabs in iPad portrait
            let tabs = ["Listen", "Notes", "Connect", "More"]

            for tab in tabs {
                navigateToTab(tab)

                // Validate basic layout
                validateNavigationBarAppearance(expectedTitle: tab)
                validateTabBarAppearance()
                validateNoWhiteBars()

                // Check main content area and adaptive layout
                if tab == "Listen" {
                    let collectionView = app.collectionViews.firstMatch
                    XCTAssertTrue(waitForElementToAppear(collectionView), "\(tab) collection view should be visible")
                    validateNoWhiteSpace(in: collectionView, description: "\(tab) collection view")

                    // Test iPad-specific collection view layout
                    Thread.sleep(forTimeInterval: 1.0)
                    let cells = collectionView.cells
                    if cells.count > 0 {
                        let firstCell = cells.element(boundBy: 0)
                        validateIPadAdaptiveLayout(element: firstCell)
                    }
                } else {
                    let tableView = app.tables.firstMatch
                    XCTAssertTrue(waitForElementToAppear(tableView), "\(tab) table view should be visible")
                    validateNoWhiteSpace(in: tableView, description: "\(tab) table view")

                    // Test iPad-specific table view layout
                    Thread.sleep(forTimeInterval: 1.0)
                    let cells = tableView.cells
                    if cells.count > 0 {
                        let firstCell = cells.element(boundBy: 0)
                        validateIPadAdaptiveLayout(element: firstCell)
                    }
                }

                takeScreenshot(name: "ipad_portrait_\(tab.lowercased())")
            }
        }
    }

    func testIPadLandscapeLayout() {
        if isIPad {
            rotateToLandscape()

            // Test all tabs in iPad landscape
            let tabs = ["Listen", "Notes", "Connect", "More"]

            for tab in tabs {
                navigateToTab(tab)

                // Validate basic layout
                validateNavigationBarAppearance(expectedTitle: tab)
                validateTabBarAppearance()
                validateNoWhiteBars()

                // Check main content area and adaptive layout
                if tab == "Listen" {
                    let collectionView = app.collectionViews.firstMatch
                    XCTAssertTrue(waitForElementToAppear(collectionView), "\(tab) collection view should be visible")
                    validateNoWhiteSpace(in: collectionView, description: "\(tab) collection view")

                    // Test iPad landscape multi-column layout
                    Thread.sleep(forTimeInterval: 1.0)
                    let cells = collectionView.cells
                    if cells.count > 1 {
                        let firstCell = cells.element(boundBy: 0)
                        let secondCell = cells.element(boundBy: 1)
                        validateIPadAdaptiveLayout(element: firstCell)

                        // Check for multi-column layout in landscape
                        let horizontalSpacing = abs(firstCell.frame.midY - secondCell.frame.midY)
                        if horizontalSpacing < 50 { // Cells are roughly on same row
                            XCTAssertLessThan(firstCell.frame.maxX, secondCell.frame.minX,
                                "iPad landscape should show multi-column layout")
                        }
                    }
                } else {
                    let tableView = app.tables.firstMatch
                    XCTAssertTrue(waitForElementToAppear(tableView), "\(tab) table view should be visible")
                    validateNoWhiteSpace(in: tableView, description: "\(tab) table view")

                    // Test iPad-specific table view layout
                    Thread.sleep(forTimeInterval: 1.0)
                    let cells = tableView.cells
                    if cells.count > 0 {
                        let firstCell = cells.element(boundBy: 0)
                        validateIPadAdaptiveLayout(element: firstCell)
                    }
                }

                takeScreenshot(name: "ipad_landscape_\(tab.lowercased())")
            }

            // Rotate back to portrait
            rotateToPortrait()
        }
    }

    // MARK: - iPad Layered Image Design Tests

    func testIPadLayeredImageDesign() {
        if isIPad {
            navigateToTab("Listen")

            let collectionView = app.collectionViews.firstMatch
            XCTAssertTrue(waitForElementToAppear(collectionView), "Collection view should be visible")

            // Wait for content to load
            Thread.sleep(forTimeInterval: 2.0)

            let cells = collectionView.cells
            if cells.count > 0 {
                let firstCell = cells.element(boundBy: 0)

                // Tap to navigate to series detail
                firstCell.tap()
                Thread.sleep(forTimeInterval: 2.0)

                // Should be in series detail view now
                let navigationBar = app.navigationBars.firstMatch
                if navigationBar.exists {
                    // iPad should show layered image design (blurred background + 16:9 foreground)
                    // We can't directly test the blur effect, but we can verify the layout

                    takeScreenshot(name: "ipad_layered_image_design")

                    // Go back
                    let backButton = navigationBar.buttons.element(boundBy: 0)
                    if backButton.exists {
                        backButton.tap()
                        Thread.sleep(forTimeInterval: 0.5)
                    }
                }
            }
        }
    }

    // MARK: - Screen Size Specific Tests

    func testSmallScreenLayout() {
        // Test on smaller iPhone screens (iPhone SE size)
        let screenBounds = app.frame
        let isSmallScreen = screenBounds.width <= 375 && screenBounds.height <= 667

        if isSmallScreen && isIPhone {
            let tabs = ["Listen", "Notes", "Connect", "More"]

            for tab in tabs {
                navigateToTab(tab)

                // Validate content fits properly on small screens
                if tab == "Listen" {
                    let collectionView = app.collectionViews.firstMatch
                    XCTAssertTrue(waitForElementToAppear(collectionView), "\(tab) collection view should be visible")

                    // Check that cells are appropriately sized for small screen
                    Thread.sleep(forTimeInterval: 1.0)
                    let cells = collectionView.cells
                    if cells.count > 0 {
                        let firstCell = cells.element(boundBy: 0)
                        XCTAssertLessThan(firstCell.frame.width, screenBounds.width - 20,
                            "Cell should fit within screen bounds with margins")
                    }
                } else {
                    let tableView = app.tables.firstMatch
                    XCTAssertTrue(waitForElementToAppear(tableView), "\(tab) table view should be visible")

                    // Check that text is readable on small screens
                    Thread.sleep(forTimeInterval: 1.0)
                    let cells = tableView.cells
                    if cells.count > 0 {
                        let firstCell = cells.element(boundBy: 0)
                        let staticTexts = firstCell.staticTexts
                        for i in 0..<min(staticTexts.count, 2) {
                            let text = staticTexts.element(boundBy: i)
                            XCTAssertGreaterThan(text.frame.height, 12,
                                "Text should be readable on small screens")
                        }
                    }
                }

                takeScreenshot(name: "small_screen_\(tab.lowercased())")
            }
        }
    }

    func testLargeScreenLayout() {
        // Test on larger iPhone screens (iPhone 15 Pro Max size)
        let screenBounds = app.frame
        let isLargeScreen = screenBounds.width >= 414 || screenBounds.height >= 896

        if isLargeScreen && isIPhone {
            let tabs = ["Listen", "Notes", "Connect", "More"]

            for tab in tabs {
                navigateToTab(tab)

                // Validate content utilizes larger screen space effectively
                if tab == "Listen" {
                    let collectionView = app.collectionViews.firstMatch
                    XCTAssertTrue(waitForElementToAppear(collectionView), "\(tab) collection view should be visible")

                    // Check that cells utilize available space
                    Thread.sleep(forTimeInterval: 1.0)
                    let cells = collectionView.cells
                    if cells.count > 0 {
                        let firstCell = cells.element(boundBy: 0)
                        XCTAssertGreaterThan(firstCell.frame.width, 200,
                            "Cell should utilize larger screen space")
                    }
                } else {
                    let tableView = app.tables.firstMatch
                    XCTAssertTrue(waitForElementToAppear(tableView), "\(tab) table view should be visible")

                    // Check that content is well-spaced on large screens
                    Thread.sleep(forTimeInterval: 1.0)
                    let cells = tableView.cells
                    if cells.count > 0 {
                        let firstCell = cells.element(boundBy: 0)
                        XCTAssertGreaterThan(firstCell.frame.width, 300,
                            "Cell should utilize larger screen space")
                    }
                }

                takeScreenshot(name: "large_screen_\(tab.lowercased())")
            }
        }
    }

    // MARK: - Orientation Change Tests

    func testOrientationChanges() {
        let tabs = ["Listen", "Notes", "Connect", "More"]

        for tab in tabs {
            navigateToTab(tab)

            // Start in portrait
            rotateToPortrait()
            Thread.sleep(forTimeInterval: 1.0)

            // Validate portrait layout
            if tab == "Listen" {
                let collectionView = app.collectionViews.firstMatch
                XCTAssertTrue(collectionView.exists, "\(tab) collection view should exist in portrait")
            } else {
                let tableView = app.tables.firstMatch
                XCTAssertTrue(tableView.exists, "\(tab) table view should exist in portrait")
            }

            // Rotate to landscape
            rotateToLandscape()
            Thread.sleep(forTimeInterval: 1.0)

            // Validate landscape layout
            if tab == "Listen" {
                let collectionView = app.collectionViews.firstMatch
                XCTAssertTrue(collectionView.exists, "\(tab) collection view should exist in landscape")
            } else {
                let tableView = app.tables.firstMatch
                XCTAssertTrue(tableView.exists, "\(tab) table view should exist in landscape")
            }

            // Rotate back to portrait
            rotateToPortrait()
            Thread.sleep(forTimeInterval: 1.0)

            // Validate portrait layout again
            if tab == "Listen" {
                let collectionView = app.collectionViews.firstMatch
                XCTAssertTrue(collectionView.exists, "\(tab) collection view should exist after rotation")
            } else {
                let tableView = app.tables.firstMatch
                XCTAssertTrue(tableView.exists, "\(tab) table view should exist after rotation")
            }

            takeScreenshot(name: "orientation_change_\(tab.lowercased())")
        }
    }
}
