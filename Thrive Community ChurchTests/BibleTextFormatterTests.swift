//
//  BibleTextFormatterTests.swift
//  Thrive Community ChurchTests
//
//  Created by AI Assistant on 2025-06-30.
//  Copyright © 2025 Thrive Community Church. All rights reserved.
//

import XCTest
@testable import Thrive_Church_Official_App

class BibleTextFormatterTests: XCTestCase {
    
    // MARK: - Basic Functionality Tests
    
    func testBasicTextFormatting() {
        let input = "Simple text without formatting"
        let result = BibleTextFormatter.formatBibleText(input)
        
        XCTAssertEqual(result.string, input)
        XCTAssertTrue(result.length > 0)
    }
    
    func testEmptyStringHandling() {
        let input = ""
        let result = BibleTextFormatter.formatBibleText(input)
        
        XCTAssertEqual(result.string, "")
        XCTAssertEqual(result.length, 0)
    }
    
    func testWhitespaceOnlyString() {
        let input = "   \n\n   "
        let result = BibleTextFormatter.formatBibleText(input)
        
        XCTAssertEqual(result.string, "")
        XCTAssertEqual(result.length, 0)
    }
    
    // MARK: - Superscript Number Tests
    
    func testSingleSuperscriptNumber() {
        let input = "¹ In the beginning was the Word"
        let result = BibleTextFormatter.formatBibleText(input)

        // Unicode superscript should be converted to regular digit
        let expectedText = "1 In the beginning was the Word"
        XCTAssertEqual(result.string, expectedText)

        // Check that the converted digit has superscript formatting
        let attributes = result.attributes(at: 0, effectiveRange: nil)

        XCTAssertNotNil(attributes[.baselineOffset])
        XCTAssertNotNil(attributes[.font])
    }
    
    func testMultipleSuperscriptNumbers() {
        let input = "¹ First verse ² Second verse ³ Third verse"
        let result = BibleTextFormatter.formatBibleText(input)

        // Unicode superscripts should be converted to regular digits
        let expectedText = "1 First verse 2 Second verse 3 Third verse"
        XCTAssertEqual(result.string, expectedText)

        // Check that all converted digits are formatted as superscripts
        let superscriptPositions = [0, 14, 28]
        for position in superscriptPositions {
            let attributes = result.attributes(at: position, effectiveRange: nil)
            XCTAssertNotNil(attributes[.baselineOffset])
        }
    }
    
    func testAllSuperscriptCharacters() {
        let input = "¹²³⁴⁵⁶⁷⁸⁹⁰ All superscript numbers"
        let result = BibleTextFormatter.formatBibleText(input)

        // Unicode superscripts should be converted to regular digits
        let expectedText = "1234567890 All superscript numbers"
        XCTAssertEqual(result.string, expectedText)

        // Check that all converted digits are formatted as superscripts
        for i in 0..<10 {
            let attributes = result.attributes(at: i, effectiveRange: nil)
            XCTAssertNotNil(attributes[.baselineOffset])
        }
    }
    
    // MARK: - Section Heading Tests
    
    func testSectionHeading() {
        let input = "Laborers in the Vineyard\n\n ¹ For the kingdom of heaven"
        let result = BibleTextFormatter.formatBibleText(input)

        // Unicode superscript should be converted
        let expectedText = "Laborers in the Vineyard\n\n 1 For the kingdom of heaven"
        XCTAssertEqual(result.string, expectedText)

        // Check that heading has different font
        let headingAttributes = result.attributes(at: 0, effectiveRange: nil)
        let font = headingAttributes[.font] as? UIFont
        XCTAssertNotNil(font)
        XCTAssertTrue(font!.fontName.contains("Heavy") || font!.fontDescriptor.symbolicTraits.contains(.traitBold))
    }
    
    func testHeadingVersusVerseDistinction() {
        let input = "Section Title\n\n ¹ Verse text"
        let result = BibleTextFormatter.formatBibleText(input)

        // Unicode superscript should be converted
        let expectedText = "Section Title\n\n 1 Verse text"
        XCTAssertEqual(result.string, expectedText)

        // Heading should not start with superscript
        let headingAttributes = result.attributes(at: 0, effectiveRange: nil)
        let headingFont = headingAttributes[.font] as? UIFont

        // Verse should have superscript formatting
        let verseIndex = result.string.firstIndex(of: "1")!
        let versePosition = result.string.distance(from: result.string.startIndex, to: verseIndex)
        let verseAttributes = result.attributes(at: versePosition, effectiveRange: nil)

        XCTAssertNotNil(headingFont)
        XCTAssertNotNil(verseAttributes[.baselineOffset])
    }
    
    // MARK: - Real Bible Text Tests
    
    func testMatthew20Passage() {
        let input = "Laborers in the Vineyard\n\n ¹ "For the kingdom of heaven is like a master of a house who went out early in the morning to hire laborers for his vineyard. ² After agreeing with the laborers for a denarius a day, he sent them into his vineyard."

        let result = BibleTextFormatter.formatBibleText(input)

        XCTAssertTrue(result.string.contains("Laborers in the Vineyard"))
        XCTAssertTrue(result.string.contains("1"))
        XCTAssertTrue(result.string.contains("2"))

        // Verify superscript formatting on converted digits
        let verse1Index = result.string.firstIndex(of: "1")!
        let verse1Position = result.string.distance(from: result.string.startIndex, to: verse1Index)
        let verse1Attributes = result.attributes(at: verse1Position, effectiveRange: nil)

        XCTAssertNotNil(verse1Attributes[.baselineOffset])
    }
    
    // MARK: - Edge Cases

    func testConsecutiveSuperscripts() {
        let input = "¹²³ Multiple consecutive superscripts"
        let result = BibleTextFormatter.formatBibleText(input)

        // Unicode superscripts should be converted to regular digits
        let expectedText = "123 Multiple consecutive superscripts"
        XCTAssertEqual(result.string, expectedText)

        // All three should be formatted as superscripts
        for i in 0..<3 {
            let attributes = result.attributes(at: i, effectiveRange: nil)
            XCTAssertNotNil(attributes[.baselineOffset])
        }
    }

    func testRegularDigitsNotFormatted() {
        let input = "23 Regular digits should not be formatted as superscripts 24 More text"
        let result = BibleTextFormatter.formatBibleText(input)

        XCTAssertEqual(result.string, input)

        // Regular digits should NOT have superscript formatting
        let attributes23 = result.attributes(at: 0, effectiveRange: nil)
        let attributes24 = result.attributes(at: 55, effectiveRange: nil)

        XCTAssertNil(attributes23[.baselineOffset])
        XCTAssertNil(attributes24[.baselineOffset])
    }

    func testUnicodeSuperscriptConversion() {
        let input = " ¹⁰ Verse ten ¹¹ Verse eleven ¹⁷ Verse seventeen"
        let result = BibleTextFormatter.formatBibleText(input)

        // Unicode superscripts should be converted to regular digits
        let expectedText = " 10 Verse ten 11 Verse eleven 17 Verse seventeen"
        XCTAssertEqual(result.string, expectedText)

        // Regular digits should have superscript formatting applied
        let verse10Index = result.string.firstIndex(of: "1")!
        let verse10Position = result.string.distance(from: result.string.startIndex, to: verse10Index)

        // Both digits of "10" should have superscript formatting
        let attributes10_1 = result.attributes(at: verse10Position, effectiveRange: nil)
        let attributes10_2 = result.attributes(at: verse10Position + 1, effectiveRange: nil)

        XCTAssertNotNil(attributes10_1[.baselineOffset])
        XCTAssertNotNil(attributes10_2[.baselineOffset])
    }
    
    func testSuperscriptInMiddleOfText() {
        let input = "Some text ¹ with superscript in middle"
        let result = BibleTextFormatter.formatBibleText(input)

        // Unicode superscript should be converted to regular digit
        let expectedText = "Some text 1 with superscript in middle"
        XCTAssertEqual(result.string, expectedText)

        let superscriptIndex = result.string.firstIndex(of: "1")!
        let position = result.string.distance(from: result.string.startIndex, to: superscriptIndex)
        let attributes = result.attributes(at: position, effectiveRange: nil)

        XCTAssertNotNil(attributes[.baselineOffset])
    }
    
    func testMultipleSections() {
        let input = "First Section\n\n ¹ First verse\n\nSecond Section\n\n ² Second verse"
        let result = BibleTextFormatter.formatBibleText(input)

        // Unicode superscripts should be converted to regular digits
        let expectedText = "First Section\n\n 1 First verse\n\nSecond Section\n\n 2 Second verse"
        XCTAssertEqual(result.string, expectedText)

        XCTAssertTrue(result.string.contains("First Section"))
        XCTAssertTrue(result.string.contains("Second Section"))
        XCTAssertTrue(result.string.contains("1"))
        XCTAssertTrue(result.string.contains("2"))
    }
    
    // MARK: - Performance Tests
    
    func testLargeTextPerformance() {
        // Create a large text with many verses
        var largeText = "Large Chapter\n\n"
        for i in 1...50 {
            let superscript = ["¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", "⁰"][i % 10]
            largeText += " \(superscript) This is verse number \(i) with some content to make it longer. "
        }
        
        measure {
            let _ = BibleTextFormatter.formatBibleText(largeText)
        }
    }
    
    // MARK: - Font and Styling Tests
    
    func testFontAttributes() {
        let input = "¹ Test verse"
        let result = BibleTextFormatter.formatBibleText(input)

        // Unicode superscript should be converted to regular digit
        let expectedText = "1 Test verse"
        XCTAssertEqual(result.string, expectedText)

        // Check base text font
        let baseAttributes = result.attributes(at: 2, effectiveRange: nil)
        let baseFont = baseAttributes[.font] as? UIFont
        XCTAssertNotNil(baseFont)
        XCTAssertEqual(baseFont?.pointSize, 16)

        // Check superscript font
        let superscriptAttributes = result.attributes(at: 0, effectiveRange: nil)
        let superscriptFont = superscriptAttributes[.font] as? UIFont
        XCTAssertNotNil(superscriptFont)
        XCTAssertEqual(superscriptFont?.pointSize, 13)

        // Check baseline offset
        let baselineOffset = superscriptAttributes[.baselineOffset] as? NSNumber
        XCTAssertNotNil(baselineOffset)
        XCTAssertEqual(baselineOffset?.doubleValue, 2.5)
    }
    
    func testColorAttributes() {
        let input = "¹ Test verse"
        let result = BibleTextFormatter.formatBibleText(input)

        // Unicode superscript should be converted to regular digit
        let expectedText = "1 Test verse"
        XCTAssertEqual(result.string, expectedText)

        let attributes = result.attributes(at: 0, effectiveRange: nil)
        let color = attributes[.foregroundColor] as? UIColor

        XCTAssertNotNil(color)
        XCTAssertEqual(color, UIColor.white)
    }
}
