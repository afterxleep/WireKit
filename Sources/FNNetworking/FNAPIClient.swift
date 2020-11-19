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
    
    init(baseURL: String,
         networkDispatcher: FNNetworkDispatcher = FNNetworkDispatcher()) {
        self.baseURL = baseURL
        self.networkDispatcher = networkDispatcher
    }
    
    func dispatch<Request: FNRequest>(_ request: Request) -> AnyPublisher<Request.ReturnType, FNNetworkRequestError> {
        guard let urlRequest = request.asURLRequest(baseURL: baseURL) else {
            return Fail(outputType: Request.ReturnType.self, failure: FNNetworkRequestError.badRequest).eraseToAnyPublisher()            
            
        }
        typealias Publisher = AnyPublisher<Request.ReturnType, FNNetworkRequestError>
        let pub: Publisher = networkDispatcher.dispatch(request: urlRequest)
        return pub
            .eraseToAnyPublisher()
    }
}
