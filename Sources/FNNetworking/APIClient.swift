//
//  APIClient.swift
//  
//
//  Created by Daniel Bernal on 14/11/20.
//

import Foundation
import Combine

struct APIClient {
    
    var baseURL: String!
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func dispatch<Request: FNRequest>(_ request: Request) -> AnyPublisher<Request.ReturnType, NetworkRequestError> {
        guard let urlRequest = request.asURLRequest(baseURL: baseURL) else {
            fatalError("Could not create urlRequest") // Properly return error here
        }
        let pub: AnyPublisher<Request.ReturnType, NetworkRequestError> = FNNetworkDispatcher().dispatch(request: urlRequest)
        return pub
            .eraseToAnyPublisher()
    }
}
