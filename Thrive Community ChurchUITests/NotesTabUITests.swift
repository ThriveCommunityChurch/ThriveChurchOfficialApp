//
//  NotesTabUITests.swift
//  Thrive Community ChurchUITests
//
//  Created by AI Assistant on Test Creation Day
//  Copyright © 2024 Thrive Community Church. All rights reserved.
//

import XCTest

class NotesTabUITests: ThriveUITestBase {
    
    override func setUp() {
        super.setUp()
        navigateToTab("Notes")
    }
    
    // MARK: - Basic Layout Tests
    
    func testNotesTabBasicLayout() {
        validateNavigationBarAppearance(expectedTitle: "Notes")
        
        // Verify table view exists and is visible
        let tableView = app.tables.firstMatch
        XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible")
        validateNoWhiteSpace(in: tableView, description: "Notes table view")
        
        takeScreenshot(name: "notes_tab_basic_layout")
    }
    
    func testNavigationBarButtons() {
        let navigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(waitForElementToAppear(navigationBar), "Navigation bar should be visible")
        
        // Check for Edit button (left side)
        let editButton = navigationBar.buttons["Edit"]
        XCTAssertTrue(editButton.exists, "Edit button should exist")
        
        // Check for Add button (right side)
        let addButton = navigationBar.buttons["Add"]
        XCTAssertTrue(addButton.exists, "Add button should exist")
        
        takeScreenshot(name: "notes_navigation_buttons")
    }
    
    func testTableViewCells() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible")
        
        // Wait for content to load
        Thread.sleep(forTimeInterval: 1.0)
        
        let cells = tableView.cells
        if cells.count > 0 {
            // Test first few cells
            let cellsToTest = min(cells.count, 3)
            for i in 0..<cellsToTest {
                let cell = cells.element(boundBy: i)
                validateNoWhiteSpace(in: cell, description: "Notes table view cell \(i)")
                
                // Validate modern card design
                XCTAssertGreaterThan(cell.frame.width, 100, "Cell should have reasonable width")
                XCTAssertGreaterThan(cell.frame.height, 70, "Cell should have reasonable height (80pt expected)")
                
                // Check for disclosure indicator
                let disclosureIndicator = cell.images.matching(identifier: "chevron.right").firstMatch
                XCTAssertTrue(disclosureIndicator.exists, "Cell should have disclosure indicator")
            }
            
            // Validate spacing between cells (card layout with 8pt spacing)
            if cells.count > 1 {
                let cellArray = (0..<min(cells.count, 3)).map { cells.element(boundBy: $0) }
                validateCardSpacing(cells: cellArray, expectedSpacing: 8)
            }
        }
        
        takeScreenshot(name: "notes_table_cells")
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
        
        takeScreenshot(name: "notes_horizontal_margins")
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
            
            takeScreenshot(name: "notes_ipad_adaptive_layout")
        }
    }
    
    func testAddNewNote() {
        let navigationBar = app.navigationBars.firstMatch
        let addButton = navigationBar.buttons["Add"]
        
        if addButton.exists {
            addButton.tap()
            
            // Wait for navigation to detail view
            Thread.sleep(forTimeInterval: 1.0)
            
            // Should navigate to detail view for new note
            let detailNavigationBar = app.navigationBars.firstMatch
            XCTAssertTrue(detailNavigationBar.exists, "Should navigate to note detail view")
            
            takeScreenshot(name: "new_note_detail_view")
            
            // Go back
            let backButton = detailNavigationBar.buttons.element(boundBy: 0)
            if backButton.exists {
                backButton.tap()
                Thread.sleep(forTimeInterval: 0.5)
            }
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
            
            // Test cell tap (should navigate to note detail)
            firstCell.tap()
            
            // Wait for navigation
            Thread.sleep(forTimeInterval: 1.0)
            
            // Should navigate to note detail view
            let detailNavigationBar = app.navigationBars.firstMatch
            XCTAssertTrue(detailNavigationBar.exists, "Should navigate to note detail")
            
            takeScreenshot(name: "note_detail_view")
            
            // Go back
            let backButton = detailNavigationBar.buttons.element(boundBy: 0)
            if backButton.exists {
                backButton.tap()
                Thread.sleep(forTimeInterval: 0.5)
            }
        }
    }
    
    func testEditMode() {
        let navigationBar = app.navigationBars.firstMatch
        let editButton = navigationBar.buttons["Edit"]
        
        if editButton.exists {
            editButton.tap()
            
            // Wait for edit mode to activate
            Thread.sleep(forTimeInterval: 0.5)
            
            // Check for Done button (replaces Edit button)
            let doneButton = navigationBar.buttons["Done"]
            XCTAssertTrue(doneButton.exists, "Done button should appear in edit mode")
            
            // Check for delete controls on cells
            let tableView = app.tables.firstMatch
            let cells = tableView.cells
            if cells.count > 0 {
                let firstCell = cells.element(boundBy: 0)
                // Look for delete button or edit controls
                let deleteButton = firstCell.buttons.matching(identifier: "Delete").firstMatch
                // Note: Delete button might not be immediately visible until swipe
            }
            
            takeScreenshot(name: "notes_edit_mode")
            
            // Exit edit mode
            doneButton.tap()
            Thread.sleep(forTimeInterval: 0.5)
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
            
            takeScreenshot(name: "notes_after_scroll")
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
            
            // Check for note text (should show either "New Note" or actual content)
            let staticTexts = firstCell.staticTexts
            XCTAssertGreaterThan(staticTexts.count, 0, "Cell should display note text")
            
            // Verify text is readable (not truncated excessively)
            for i in 0..<min(staticTexts.count, 2) {
                let text = staticTexts.element(boundBy: i)
                XCTAssertGreaterThan(text.frame.width, 50, "Text should have reasonable width")
                XCTAssertGreaterThan(text.frame.height, 10, "Text should have reasonable height")
            }
        }
        
        takeScreenshot(name: "notes_cell_content")
    }
    
    func testNoWhiteBarsOnIPad() {
        if isIPad {
            validateNoWhiteBars()
            takeScreenshot(name: "notes_ipad_no_white_bars")
        }
    }
    
    // MARK: - Orientation Tests
    
    func testLandscapeLayout() {
        rotateToLandscape()
        
        // Re-validate layout in landscape
        let tableView = app.tables.firstMatch
        XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible in landscape")
        validateNoWhiteSpace(in: tableView, description: "Notes table view in landscape")
        
        if isIPad {
            validateNoWhiteBars()
            
            // iPad landscape should still respect content width constraints
            let cells = tableView.cells
            if cells.count > 0 {
                let firstCell = cells.element(boundBy: 0)
                validateIPadAdaptiveLayout(element: firstCell)
            }
        }
        
        takeScreenshot(name: "notes_landscape_layout")
        
        // Rotate back to portrait
        rotateToPortrait()
    }
    
    func testPortraitLayout() {
        rotateToPortrait()
        
        // Re-validate layout in portrait
        let tableView = app.tables.firstMatch
        XCTAssertTrue(waitForElementToAppear(tableView), "Table view should be visible in portrait")
        validateNoWhiteSpace(in: tableView, description: "Notes table view in portrait")
        
        if isIPad {
            validateNoWhiteBars()
        }
        
        takeScreenshot(name: "notes_portrait_layout")
    }
    
    // MARK: - Typography and Design Tests
    
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
            
            // Check for proper text hierarchy (title and subtitle)
            let staticTexts = firstCell.staticTexts
            if staticTexts.count > 1 {
                let titleText = staticTexts.element(boundBy: 0)
                let subtitleText = staticTexts.element(boundBy: 1)
                
                // Title should be larger/more prominent than subtitle
                XCTAssertGreaterThanOrEqual(titleText.frame.height, subtitleText.frame.height,
                    "Title text should be at least as tall as subtitle")
            }
        }
        
        takeScreenshot(name: "notes_modern_card_design")
    }
}
