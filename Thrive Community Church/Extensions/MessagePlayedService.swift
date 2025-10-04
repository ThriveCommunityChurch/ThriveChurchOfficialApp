//
//  MessagePlayedService.swift
//  Thrive Church Official App
//
//  Created by Augment Agent on 1/2/25.
//  Copyright © 2025 Thrive Community Church. All rights reserved.
//

import Foundation

/// Service class for marking sermon messages as played via the ThriveChurch API
/// Designed to be completely transparent to users - works when possible but never interrupts playback
class MessagePlayedService {

    // MARK: - Singleton
    static let shared = MessagePlayedService()

    private init() {}

    // MARK: - Public Methods

    /// Marks a sermon message as played by calling the API endpoint
    /// This method is designed to be completely transparent - it never interrupts playback
    /// - Parameter messageId: The unique identifier of the sermon message
    func markMessageAsPlayed(messageId: String) {
        // Perform all operations on a background queue to avoid blocking playback
        DispatchQueue.global(qos: .utility).async { [weak self] in
            self?.performMarkAsPlayedRequest(messageId: messageId)
        }
    }

    // MARK: - Private Methods

    /// Performs the actual API request with comprehensive error handling
    /// - Parameter messageId: The unique identifier of the sermon message
    private func performMarkAsPlayedRequest(messageId: String) {
        // Validate input parameters
        guard !messageId.isEmpty else {
            print("MessagePlayedService: Cannot mark message as played - messageId is empty")
            return
        }

        // Check network availability using existing reachability service
        guard let networkStatus = Network.reachability?.status, networkStatus != .unreachable else {
            print("MessagePlayedService: Skipping API call - no network connectivity")
            return
        }

        // Get API domain from UserDefaults
        guard let apiDomain = UserDefaults.standard.string(forKey: ApplicationVariables.ApiCacheKey),
              !apiDomain.isEmpty else {
            print("MessagePlayedService: Cannot mark message as played - API domain not found")
            return
        }

        // Construct and validate URL
        let apiUrl = "http://\(apiDomain)/"
        let endpoint = "\(apiUrl)api/sermons/series/message/\(messageId)/played"

        guard let url = URL(string: endpoint) else {
            print("MessagePlayedService: Invalid URL constructed: \(endpoint)")
            return
        }

        print("MessagePlayedService: Marking message \(messageId) as played")

        // Configure request with timeout
        var request = URLRequest(url: url)
        request.timeoutInterval = 10.0
        request.httpMethod = "GET"

        // Make the API call with error handling
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            self?.handleAPIResponse(data: data, response: response, error: error, messageId: messageId)
        }.resume()
    }

    /// Handles the API response with simple error handling
    /// - Parameters:
    ///   - data: Response data from the API
    ///   - response: HTTP response object
    ///   - error: Any error that occurred during the request
    ///   - messageId: The message ID for logging context
    private func handleAPIResponse(data: Data?, response: URLResponse?, error: Error?, messageId: String) {
        // Handle any errors (network, timeout, etc.)
        if let error = error {
            print("MessagePlayedService: Failed to mark message \(messageId) as played - \(error.localizedDescription)")
            return
        }

        // Handle HTTP response
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                print("MessagePlayedService: Successfully marked message \(messageId) as played")
            } else {
                print("MessagePlayedService: API returned status code \(httpResponse.statusCode) for message \(messageId)")
            }
        }
    }
}
