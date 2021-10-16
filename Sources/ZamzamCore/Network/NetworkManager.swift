//
//  NetworkManager.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-02-27.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLRequest

/// A manager that creates and manages network requests.
///
/// Create requests using the extensions available for `URLRequest` that provides the URL, parameters, headers, and so on.
/// The network service provided in the intializer handles cache policy, trust management, and other underlying details.
///
///     let request = URLRequest(
///         url: URL(string: "https://httpbin.org/get")!,
///         method: .get,
///         parameters: [
///             "abc": 123,
///             "def": "test456",
///             "xyz": true
///         ],
///         headers: [
///             "Abc": "test123",
///             "Def": "test456",
///             "Xyz": "test789"
///         ]
///     )
///
///     let networkManager = NetworkManager(
///         service: NetworkServiceFoundation()
///     )
///
///     do {
///         let response = try await networkManager.send(request)
///     } catch let error as NetworkError {
///         print(error.statusCode)
///     } catch {
///         print("Unknown error")
///     }
public struct NetworkManager {
    private let service: NetworkService
    private let adapter: URLRequestAdapter?

    /// Creates a network wrapper to handle HTTP requests.
    ///
    /// - Parameters:
    ///   - service: A service that performs the underlying HTTP request with a session.
    ///   - adapter: Inspects and adapts the specified `URLRequest` in some manner and returns the new request.
    public init(service: NetworkService, adapter: URLRequestAdapter? = nil) {
        self.service = service
        self.adapter = adapter
    }
}

public extension NetworkManager {
    /// Creates a task that retrieves the contents of a URL based on the specified request object, and calls a handler upon completion.
    ///
    /// - Parameter request: A network request object that provides the URL, parameters, headers, and so on.
    /// - Returns: The server response with included details from the network request.
    @discardableResult
    func send(_ request: URLRequest) async throws -> NetworkResponse {
        let request = adapter?.adapt(request) ?? request
        return try await service.send(request)
    }
}
