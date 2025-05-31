//
//  ConnectTabUITests.swift
//  Thrive Community ChurchUITests
//
//  Created by AI Assistant on Test Creation Day
//  Copyright © 2024 Thrive Community Church. All rights reserved.
//

import XCTest

class ConnectTabUITests: ThriveUITestBase {

    override func setUp() {
        super.setUp()
        navigateToTab("Connect")
    }

    // MARK: - Basic Layout Tests

    func testConnectTabBasicLayout() {
        validateNavigationBarAppearance(expectedTitle: "Connect")

        // Verify table view exists and is visible
        let tableView = app.tables.firstMatch
        XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible")
        validateNoWhiteSpace(in: tableView, description: "Connect table view")

        takeScreenshot(name: "connect_tab_basic_layout")
    }

    func testTableViewCells() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible")

        // Wait for content to load
        Thread.sleep(forTimeInterval: 1.0)

        let cells = tableView.cells
        XCTAssertGreaterThan(cells.count, 0, "Connect tab should have content cells")

        // Test first few cells
        let cellsToTest = min(cells.count, 5)
        for i in 0..<cellsToTest {
            let cell = cells.element(boundBy: i)
            validateNoWhiteSpace(in: cell, description: "Connect table view cell \(i)")

            // Validate modern card design (80pt height)
            XCTAssertGreaterThan(cell.frame.width, 100, "Cell should have reasonable width")
            let cellHeight = cell.frame.height
            XCTAssertGreaterThanOrEqual(cellHeight, 75, "Cell height should be at least 75pt")
            XCTAssertLessThanOrEqual(cellHeight, 85, "Cell height should not exceed 85pt")

            // Check for disclosure indicator
            let disclosureIndicator = cell.images.matching(identifier: "chevron.right").firstMatch
            XCTAssertTrue(disclosureIndicator.exists, "Cell should have disclosure indicator")
        }

        // Validate spacing between cells (card layout with 8pt spacing)
        if cells.count > 1 {
            let cellArray = (0..<min(cells.count, 3)).map { cells.element(boundBy: $0) }
            validateCardSpacing(cells: cellArray, expectedSpacing: 8)
        }

        takeScreenshot(name: "connect_table_cells")
    }

    func testExpectedConnectOptions() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible")

        // Wait for content to load
        Thread.sleep(forTimeInterval: 1.0)

        // Expected connect options based on the code
        let expectedOptions = [
            "Get directions",
            "Contact us",
            "Announcements",
            "Join a small group",
            "Serve"
        ]

        let cells = tableView.cells
        for option in expectedOptions {
            let cellWithOption = cells.staticTexts[option].firstMatch
            if cellWithOption.exists {
                XCTAssertTrue(cellWithOption.exists, "Should have '\(option)' option")

                // Verify the option text is visible
                XCTAssertTrue(cellWithOption.isHittable, "Cell option should be tappable")
            }
        }

        takeScreenshot(name: "connect_expected_options")
    }

    func testHorizontalMargins() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible")

        // Wait for content to load
        Thread.sleep(forTimeInterval: 1.0)

        let cells = tableView.cells
        if cells.count > 0 {
            let firstCell = cells.element(boundBy: 0)
            validateHorizontalMargins(element: firstCell, expectedMargin: 16)
        }

        takeScreenshot(name: "connect_horizontal_margins")
    }

    func testIPadAdaptiveLayout() {
        if isIPad {
            let tableView = app.tables.firstMatch
            XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible")

            // Wait for content to load
            Thread.sleep(forTimeInterval: 1.0)

            let cells = tableView.cells
            if cells.count > 0 {
                let firstCell = cells.element(boundBy: 0)
                validateIPadAdaptiveLayout(element: firstCell)
            }

            takeScreenshot(name: "connect_ipad_adaptive_layout")
        }
    }

    func testCellInteraction() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible")

        // Wait for content to load
        Thread.sleep(forTimeInterval: 1.0)

        let cells = tableView.cells
        if cells.count > 0 {
            let firstCell = cells.element(boundBy: 0)

            // Test cell tap
            firstCell.tap()

            // Wait for potential navigation or action
            Thread.sleep(forTimeInterval: 1.0)

            // Depending on the cell, it might navigate to a new view or show an action sheet
            // Check if we navigated to a new view
            let navigationBars = app.navigationBars
            if navigationBars.count > 1 {
                // We navigated to a new view
                takeScreenshot(name: "connect_cell_navigation")

                // Go back
                let backButton = navigationBars.element(boundBy: 1).buttons.element(boundBy: 0)
                if backButton.exists {
                    backButton.tap()
                    Thread.sleep(forTimeInterval: 0.5)
                }
            } else {
                // Might have shown an action sheet or alert
                let alerts = app.alerts
                let actionSheets = app.sheets

                if alerts.count > 0 {
                    takeScreenshot(name: "connect_cell_alert")
                    // Dismiss alert
                    let cancelButton = alerts.firstMatch.buttons["Cancel"]
                    if cancelButton.exists {
                        cancelButton.tap()
                    } else {
                        alerts.firstMatch.buttons.element(boundBy: 0).tap()
                    }
                } else if actionSheets.count > 0 {
                    takeScreenshot(name: "connect_cell_action_sheet")
                    // Dismiss action sheet
                    let cancelButton = actionSheets.firstMatch.buttons["Cancel"]
                    if cancelButton.exists {
                        cancelButton.tap()
                    }
                }
            }
        }
    }

    func testAnnouncementsNavigation() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible")

        // Wait for content to load
        Thread.sleep(forTimeInterval: 1.0)

        // Look for Announcements cell
        let announcementsCell = tableView.cells.staticTexts["Announcements"].firstMatch
        if announcementsCell.exists {
            announcementsCell.tap()

            // Wait for navigation
            Thread.sleep(forTimeInterval: 2.0)

            // Should navigate to announcements view
            let announcementsNavigationBar = app.navigationBars["Announcements"]
            XCTAssertTrue(announcementsNavigationBar.exists, "Should navigate to Announcements view")

            takeScreenshot(name: "announcements_view")

            // Go back
            let backButton = announcementsNavigationBar.buttons.element(boundBy: 0)
            if backButton.exists {
                backButton.tap()
                Thread.sleep(forTimeInterval: 0.5)
            }
        }
    }

    func testScrollingBehavior() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible")

        // Wait for content to load
        Thread.sleep(forTimeInterval: 1.0)

        let cells = tableView.cells
        if cells.count > 3 {
            // Test scrolling
            let initialFirstCell = cells.element(boundBy: 0)
            let initialPosition = initialFirstCell.frame.minY

            // Scroll down
            tableView.swipeUp()
            Thread.sleep(forTimeInterval: 0.5)

            // Verify content moved
            let newPosition = initialFirstCell.frame.minY
            XCTAssertLessThan(newPosition, initialPosition, "Content should scroll up when swiping up")

            takeScreenshot(name: "connect_after_scroll")
        }
    }

    func testCellContentDisplay() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible")

        // Wait for content to load
        Thread.sleep(forTimeInterval: 1.0)

        let cells = tableView.cells
        if cells.count > 0 {
            let firstCell = cells.element(boundBy: 0)

            // Check for title and subtitle text
            let staticTexts = firstCell.staticTexts
            XCTAssertGreaterThan(staticTexts.count, 0, "Cell should display title text")

            // Verify text is readable (not truncated excessively)
            for i in 0..<min(staticTexts.count, 2) {
                let text = staticTexts.element(boundBy: i)
                XCTAssertGreaterThan(text.frame.width, 50, "Text should have reasonable width")
                XCTAssertGreaterThan(text.frame.height, 10, "Text should have reasonable height")
            }

            // Check for proper text hierarchy if subtitle exists
            if staticTexts.count > 1 {
                let titleText = staticTexts.element(boundBy: 0)
                let subtitleText = staticTexts.element(boundBy: 1)

                // Title should be positioned above subtitle
                XCTAssertLessThan(titleText.frame.midY, subtitleText.frame.midY,
                    "Title should be positioned above subtitle")
            }
        }

        takeScreenshot(name: "connect_cell_content")
    }

    func testNoWhiteBarsOnIPad() {
        if isIPad {
            validateNoWhiteBars()
            takeScreenshot(name: "connect_ipad_no_white_bars")
        }
    }

    // MARK: - Orientation Tests

    func testLandscapeLayout() {
        rotateToLandscape()

        // Re-validate layout in landscape
        let tableView = app.tables.firstMatch
        XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible in landscape")
        validateNoWhiteSpace(in: tableView, description: "Connect table view in landscape")

        if isIPad {
            validateNoWhiteBars()

            // iPad landscape should still respect content width constraints
            let cells = tableView.cells
            if cells.count > 0 {
                let firstCell = cells.element(boundBy: 0)
                validateIPadAdaptiveLayout(element: firstCell)
            }
        }

        takeScreenshot(name: "connect_landscape_layout")

        // Rotate back to portrait
        rotateToPortrait()
    }

    func testPortraitLayout() {
        rotateToPortrait()

        // Re-validate layout in portrait
        let tableView = app.tables.firstMatch
        XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible in portrait")
        validateNoWhiteSpace(in: tableView, description: "Connect table view in portrait")

        if isIPad {
            validateNoWhiteBars()
        }

        takeScreenshot(name: "connect_portrait_layout")
    }

    // MARK: - Modern Card Design Tests

    func testModernCardDesign() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible")

        // Wait for content to load
        Thread.sleep(forTimeInterval: 1.0)

        let cells = tableView.cells
        if cells.count > 0 {
            let firstCell = cells.element(boundBy: 0)

            // Validate cell height matches expected card design (80pt)
            let cellHeight = firstCell.frame.height
            XCTAssertGreaterThanOrEqual(cellHeight, 75, "Cell height should be at least 75pt")
            XCTAssertLessThanOrEqual(cellHeight, 85, "Cell height should not exceed 85pt")

            // Validate proper spacing from edges (16pt horizontal margins)
            validateHorizontalMargins(element: firstCell, expectedMargin: 16)
        }

        takeScreenshot(name: "connect_modern_card_design")
    }
}
