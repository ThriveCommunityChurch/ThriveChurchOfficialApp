//
//  StringExtensions.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/28/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

extension String {
	
	func FormatDateFromISO8601ForUI() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		let date = dateFormatter.date(from: self)
		
		// since we may not be able to make a deep copy of the object, we should
		// just return what is requested because it's probably already formatted
		if date == nil {
			return self
		}
		
		let dateToStringFormatter = DateFormatter()
		dateToStringFormatter.dateFormat = "M.d.yy"
		dateToStringFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		let dateString = dateToStringFormatter.string(from: date!)
		
		return dateString
	}
}

// MARK: - Bible Text Formatting

class BibleTextFormatter {

    // MARK: - Text Styles

    private static func baseTextAttributes() -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = .left

        return [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Avenir-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16),
            .paragraphStyle: paragraphStyle
        ]
    }

    private static func headingTextAttributes() -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.alignment = .left
        paragraphStyle.paragraphSpacingBefore = 8
        paragraphStyle.paragraphSpacing = 8

        return [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Avenir-Heavy", size: 18) ?? UIFont.boldSystemFont(ofSize: 18),
            .paragraphStyle: paragraphStyle
        ]
    }

    private static func superscriptTextAttributes() -> [NSAttributedString.Key: Any] {
        return [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Avenir-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13),
            .baselineOffset: 2.5
        ]
    }

    // MARK: - Public Methods

    static func formatBibleText(_ rawText: String) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString()

        // Process text sections efficiently
        processSections(rawText, into: mutableAttributedString)

        // Apply consistent paragraph formatting
        addParagraphSpacing(to: mutableAttributedString)

        return mutableAttributedString
    }

    private static func processSections(_ rawText: String, into attributedString: NSMutableAttributedString) {
        // Split text into sections by double newlines
        let sections = rawText.components(separatedBy: "\n\n")

        for (index, section) in sections.enumerated() {
            let trimmedSection = section.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedSection.isEmpty else { continue }

            // Determine section type and format accordingly
            if isHeading(trimmedSection) {
                appendHeading(trimmedSection, to: attributedString)
            } else {
                appendFormattedVerse(trimmedSection, to: attributedString)
            }

            // Add spacing between sections
            if index < sections.count - 1 {
                attributedString.append(NSAttributedString(string: "\n\n"))
            }
        }
    }

    // MARK: - Private Methods

    private static func isHeading(_ text: String) -> Bool {
        // Convert Unicode superscripts to regular digits first
        let convertedText = convertUnicodeSuperscriptsToRegularDigits(text)

        // Headings don't start with verse numbers (regular digits)
        let versePattern = "^\\s*\\d+\\s"
        guard let regex = try? NSRegularExpression(pattern: versePattern) else { return true }
        let range = NSRange(location: 0, length: convertedText.count)
        return regex.firstMatch(in: convertedText, range: range) == nil
    }

    private static func appendHeading(_ text: String, to attributedString: NSMutableAttributedString) {
        let headingString = NSAttributedString(string: text, attributes: headingTextAttributes())
        attributedString.append(headingString)
    }

    private static func appendFormattedVerse(_ text: String, to attributedString: NSMutableAttributedString) {
        let mutableText = NSMutableAttributedString(string: text, attributes: baseTextAttributes())

        // Find and format all superscript numbers efficiently
        formatSuperscriptNumbers(in: mutableText, originalText: text)

        attributedString.append(mutableText)
    }

    private static func formatSuperscriptNumbers(in attributedString: NSMutableAttributedString, originalText: String) {
        // First, convert Unicode superscript characters to regular digits
        let convertedText = convertUnicodeSuperscriptsToRegularDigits(originalText)

        // Update the attributed string with converted text
        attributedString.mutableString.setString(convertedText)

        // Now match regular verse numbers at start of line/after whitespace
        let verseNumberPattern = "(?:^|\\s)(\\d+)(?=\\s)"
        guard let regex = try? NSRegularExpression(pattern: verseNumberPattern) else { return }

        let range = NSRange(location: 0, length: convertedText.count)
        let matches = regex.matches(in: convertedText, range: range)

        // Apply superscript formatting to matches (in reverse order to maintain ranges)
        for match in matches.reversed() {
            // Get the range of just the number part (group 1)
            if match.numberOfRanges > 1 {
                let numberRange = match.range(at: 1)
                attributedString.setAttributes(superscriptTextAttributes(), range: numberRange)
            }
        }
    }

    private static func convertUnicodeSuperscriptsToRegularDigits(_ text: String) -> String {
        let superscriptMap: [Character: Character] = [
            "¹": "1", "²": "2", "³": "3", "⁴": "4", "⁵": "5",
            "⁶": "6", "⁷": "7", "⁸": "8", "⁹": "9", "⁰": "0"
        ]

        return String(text.map { superscriptMap[$0] ?? $0 })
    }

    // MARK: - Paragraph Formatting

    private static func addParagraphSpacing(to attributedString: NSMutableAttributedString) {
        // Apply consistent spacing and margins for readability
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.paragraphSpacing = 12
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 0
        paragraphStyle.tailIndent = 0

        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
    }
}
