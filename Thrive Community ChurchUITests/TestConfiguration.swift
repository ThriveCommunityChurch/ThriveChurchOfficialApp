//
//  TestConfiguration.swift
//  Thrive Community ChurchUITests
//
//  Created by AI Assistant on Test Creation Day
//  Copyright © 2024 Thrive Community Church. All rights reserved.
//

import XCTest

// MARK: - Test Configuration Constants

struct TestConfiguration {
    
    // MARK: - Device Configurations
    
    static let supportedDevices: [String] = [
        "iPhone SE (3rd generation)",      // Small iPhone
        "iPhone 15 Pro Max",               // Large iPhone
        "iPad (10th generation)",          // Standard iPad
        "iPad Pro (12.9-inch) (6th generation)" // Large iPad
    ]
    
    // MARK: - Layout Constants
    
    struct Layout {
        static let horizontalMargin: CGFloat = 16
        static let verticalSpacing: CGFloat = 8
        static let cardCornerRadius: CGFloat = 12
        static let cardHeight: CGFloat = 80
        static let shadowOffset: CGSize = CGSize(width: 0, height: 4)
        static let shadowRadius: CGFloat = 8
        static let shadowOpacity: Float = 0.4
        static let maxContentWidth: CGFloat = 600 // iPad constraint
        static let minimumTouchTarget: CGFloat = 44
    }
    
    // MARK: - App Structure
    
    struct Tabs {
        static let all = ["Listen", "Notes", "Connect", "More"]
        static let listen = "Listen"
        static let notes = "Notes"
        static let connect = "Connect"
        static let more = "More"
    }
    
    struct NavigationButtons {
        static let recentlyPlayed = "RecentlyPlayed"
        static let nowPlaying = "playback"
        static let add = "Add"
        static let edit = "Edit"
        static let done = "Done"
    }
    
    // MARK: - Expected Content
    
    struct ConnectOptions {
        static let all = [
            "Get directions",
            "Contact us",
            "Announcements", 
            "Join a small group",
            "Serve"
        ]
    }
    
    struct MoreOptions {
        static let all = [
            "I'm New",
            "Give",
            "Social",
            "Meet the team",
            "Bible",
            "Settings",
            "About",
            "Send Logs"
        ]
    }
    
    // MARK: - Test Timeouts
    
    struct Timeouts {
        static let elementAppear: TimeInterval = 10
        static let elementDisappear: TimeInterval = 5
        static let navigation: TimeInterval = 2
        static let contentLoad: TimeInterval = 3
        static let animation: TimeInterval = 1
        static let rotation: TimeInterval = 1
    }
    
    // MARK: - Screenshot Configuration
    
    struct Screenshots {
        static let quality: XCTAttachment.Lifetime = .keepAlways
        
        static func name(for test: String, device: String, orientation: String) -> String {
            return "\(test)_\(device)_\(orientation)"
        }
        
        static func deviceSuffix(isIPad: Bool) -> String {
            return isIPad ? "ipad" : "iphone"
        }
        
        static func orientationSuffix(isLandscape: Bool) -> String {
            return isLandscape ? "landscape" : "portrait"
        }
    }
    
    // MARK: - Validation Thresholds
    
    struct Validation {
        static let spacingTolerance: CGFloat = 2
        static let marginTolerance: CGFloat = 2
        static let aspectRatioMin: CGFloat = 0.8
        static let aspectRatioMax: CGFloat = 2.0
        static let centeringTolerance: CGFloat = 10
        static let scrollPerformanceMax: TimeInterval = 2.0
    }
    
    // MARK: - Test Data
    
    struct TestData {
        static let sampleNoteText = "This is a sample note for testing purposes"
        static let longNoteText = """
        This is a longer note that spans multiple lines to test text wrapping and display.
        It should show proper typography hierarchy with title and preview text.
        The cell should handle this content gracefully without truncation issues.
        """
    }
}

// MARK: - Test Utilities Extension

extension TestConfiguration {
    
    // MARK: - Device Detection Helpers
    
    static func isSmallScreen() -> Bool {
        let bounds = XCUIScreen.main.bounds
        return bounds.width <= 375 && bounds.height <= 667
    }
    
    static func isLargeScreen() -> Bool {
        let bounds = XCUIScreen.main.bounds
        return bounds.width >= 414 || bounds.height >= 896
    }
    
    static func isIPadSize() -> Bool {
        let bounds = XCUIScreen.main.bounds
        return min(bounds.width, bounds.height) >= 768
    }
    
    // MARK: - Test Environment Setup
    
    static func setupTestEnvironment() {
        // Configure test environment settings
        // This could include setting up mock data, network conditions, etc.
    }
    
    static func resetTestEnvironment() {
        // Reset any test-specific configurations
        // Clear caches, reset user defaults, etc.
    }
    
    // MARK: - Validation Helpers
    
    static func isValidCardHeight(_ height: CGFloat) -> Bool {
        return height >= (Layout.cardHeight - 5) && height <= (Layout.cardHeight + 5)
    }
    
    static func isValidHorizontalMargin(_ margin: CGFloat) -> Bool {
        return margin >= (Layout.horizontalMargin - Validation.marginTolerance) &&
               margin <= (Layout.horizontalMargin + Validation.marginTolerance)
    }
    
    static func isValidVerticalSpacing(_ spacing: CGFloat) -> Bool {
        return spacing >= (Layout.verticalSpacing - Validation.spacingTolerance) &&
               spacing <= (Layout.verticalSpacing + Validation.spacingTolerance)
    }
    
    static func isValidTouchTarget(_ size: CGSize) -> Bool {
        return max(size.width, size.height) >= Layout.minimumTouchTarget
    }
    
    static func isValidAspectRatio(_ ratio: CGFloat) -> Bool {
        return ratio >= Validation.aspectRatioMin && ratio <= Validation.aspectRatioMax
    }
    
    // MARK: - Test Reporting Helpers
    
    static func generateTestReport(results: [String: Bool]) -> String {
        var report = "UI Test Results Summary:\n"
        report += "========================\n\n"
        
        let passed = results.values.filter { $0 }.count
        let total = results.count
        
        report += "Overall: \(passed)/\(total) tests passed\n\n"
        
        for (test, result) in results.sorted(by: { $0.key < $1.key }) {
            let status = result ? "✅ PASS" : "❌ FAIL"
            report += "\(status) \(test)\n"
        }
        
        return report
    }
    
    // MARK: - Performance Monitoring
    
    static func measureScrollPerformance(in element: XCUIElement, iterations: Int = 3) -> TimeInterval {
        var totalTime: TimeInterval = 0
        
        for _ in 0..<iterations {
            let startTime = Date()
            element.swipeUp()
            element.swipeDown()
            let endTime = Date()
            
            totalTime += endTime.timeIntervalSince(startTime)
        }
        
        return totalTime / Double(iterations)
    }
    
    // MARK: - Debug Helpers
    
    static func printElementHierarchy(_ element: XCUIElement) {
        print("Element Hierarchy:")
        print("==================")
        print(element.debugDescription)
    }
    
    static func printScreenInfo() {
        let bounds = XCUIScreen.main.bounds
        let scale = XCUIScreen.main.scale
        
        print("Screen Information:")
        print("==================")
        print("Bounds: \(bounds)")
        print("Scale: \(scale)")
        print("Device Type: \(isIPadSize() ? "iPad" : "iPhone")")
        print("Screen Size: \(isSmallScreen() ? "Small" : isLargeScreen() ? "Large" : "Standard")")
    }
}

// MARK: - Test Result Tracking

class TestResultTracker {
    private var results: [String: Bool] = [:]
    
    func recordResult(for test: String, passed: Bool) {
        results[test] = passed
    }
    
    func getResults() -> [String: Bool] {
        return results
    }
    
    func generateReport() -> String {
        return TestConfiguration.generateTestReport(results: results)
    }
    
    func reset() {
        results.removeAll()
    }
    
    var passRate: Double {
        guard !results.isEmpty else { return 0.0 }
        let passed = results.values.filter { $0 }.count
        return Double(passed) / Double(results.count)
    }
}
