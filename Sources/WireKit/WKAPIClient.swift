//
//  WKAPIClient.swift
//  
//
//  Created by Daniel Bernal on 14/11/20.
//  © 2020 - Les Mobiles
//  MIT License
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
    /// - Returns: A publisher containing decoded data or an error
    public func dispatch<Request: WKRequest>(_ request: Request) -> AnyPublisher<Request.ReturnType, WKNetworkRequestError> {
        guard let urlRequest = request.asURLRequest(baseURL: baseURL) else {
            return Fail(outputType: Request.ReturnType.self, failure: WKNetworkRequestError.badRequest).eraseToAnyPublisher()
            
        }
        typealias Publisher = AnyPublisher<Request.ReturnType, WKNetworkRequestError>
        let pub: Publisher = networkDispatcher.dispatch(request: urlRequest)
        return pub.eraseToAnyPublisher()
    }
}
