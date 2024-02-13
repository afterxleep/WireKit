//
//  WKAPIClient.swift
//  
//
//  Created by Daniel Bernal on 14/11/20.
//


import Foundation
import Combine

public struct WKAPIClient {
    
    public var baseURL: String!
    public var networkDispatcher: WKNetworkDispatcher!
    
    public init(baseURL: String,
                networkDispatcher: WKNetworkDispatcher = WKNetworkDispatcher()) {
        self.baseURL = baseURL
        self.networkDispatcher = networkDispatcher
    }
    
    /// Dispatches an WKRequest and returns a publisher
    /// - Parameter request: WKRequest to Dispatch
    /// - Returns: The generic return typ
    public func dispatch<Request: WKRequest>(_ request: Request) async throws -> Request.ReturnType {
            guard let urlRequest = request.asURLRequest(baseURL: baseURL) else {
                throw WKNetworkRequestError.badRequest()
            }
            return try await networkDispatcher.dispatch(request: urlRequest, decoder: request.decoder)
        }
}
