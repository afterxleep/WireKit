//
//  APIClient.swift
//  
//
//  Created by Daniel Bernal on 14/11/20.
//

import Foundation
import Combine

struct FNAPIClient {
    
    var baseURL: String!
    var networkDispatcher: FNNetworkDispatcher!
    
    init(baseURL: String, networkDispatcher: FNNetworkDispatcher = FNNetworkDispatcher()) {
        self.baseURL = baseURL
        self.networkDispatcher = networkDispatcher
    }
    
    func dispatch<Request: FNRequest>(_ request: Request) -> AnyPublisher<Request.ReturnType, NetworkRequestError> {
        guard let urlRequest = request.asURLRequest(baseURL: baseURL) else {
            fatalError("Could not create urlRequest")
        }
        typealias Publisher = AnyPublisher<Request.ReturnType, NetworkRequestError>
        let pub: Publisher = networkDispatcher.dispatch(request: urlRequest)
        return pub
            .eraseToAnyPublisher()
    }
}
