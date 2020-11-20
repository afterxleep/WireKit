//
//  FNAPIClient.swift
//  
//
//  Created by Daniel Bernal on 14/11/20.
//  © 2020 - Les Mobiles
//  MIT License
//


import Foundation
import Combine

public struct FNAPIClient {
    
    public var baseURL: String!
    public var networkDispatcher: FNNetworkDispatcher!
    
    public init(baseURL: String,
                networkDispatcher: FNNetworkDispatcher = FNNetworkDispatcher()) {
        self.baseURL = baseURL
        self.networkDispatcher = networkDispatcher
    }
    
    /// Dispatches an FNRequest and returns a publisher
    /// - Parameter request: FNRequest to Dispatch
    /// - Returns: A publisher containing decoded data or an error
    public func dispatch<Request: FNRequest>(_ request: Request) -> AnyPublisher<Request.ReturnType, FNNetworkRequestError> {
        guard let urlRequest = request.asURLRequest(baseURL: baseURL) else {
            return Fail(outputType: Request.ReturnType.self, failure: FNNetworkRequestError.badRequest).eraseToAnyPublisher()
            
        }
        typealias Publisher = AnyPublisher<Request.ReturnType, FNNetworkRequestError>
        let pub: Publisher = networkDispatcher.dispatch(request: urlRequest)
        return pub.eraseToAnyPublisher()
    }
}
