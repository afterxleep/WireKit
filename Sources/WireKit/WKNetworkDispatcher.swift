//
//  WKNetworkDispatcher.swift
//  
//
//  Created by Daniel Bernal on 15/11/20.
//


import Combine
import Foundation

public enum WKNetworkRequestError: LocalizedError, Equatable {
    case invalidRequest(_ data: Data? = nil)
    case badRequest(_ data: Data? = nil)
    case unauthorized(_ data: Data? = nil)
    case forbidden(_ data: Data? = nil)
    case notFound(_ data: Data? = nil)
    case error4xx(_ code: Int, data: Data? = nil)
    case serverError(_ data: Data? = nil)
    case error5xx(_ code: Int, data: Data? = nil)
    case decodingError(_ description: String)
    case urlSessionFailed(_ error: URLError)
    case unknownError(_ data: Data? = nil)
}

public struct WKNetworkDispatcher {
        
    let urlSession: URLSession!
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    /// Dispatches an URLRequest and returns a publisher
    /// - Parameter request: URLRequest
    /// - Returns: A publisher with the provided decoded data or an error
    public func dispatch<ReturnType: Codable>(request: URLRequest, decoder: JSONDecoder?) -> AnyPublisher<ReturnType, WKNetworkRequestError> {

        let decoder = decoder ?? JSONDecoder()

        return urlSession
            .dataTaskPublisher(for: request)
            .tryMap({ data, response in
                if let response = response as? HTTPURLResponse,
                 !(200...299).contains(response.statusCode) {
                    throw httpError(response.statusCode, data: data)
                }
                return data
            })
            .decode(type: ReturnType.self, decoder: decoder)
            .mapError { error in
               handleError(error)
            }
            .eraseToAnyPublisher()
    }
    
    
    /// Parses a HTTP StatusCode and returns a proper error
    /// - Parameter statusCode: HTTP status code
    /// - Returns: Mapped Error
    private func httpError(_ statusCode: Int, data: Data?) -> WKNetworkRequestError {
        switch statusCode {
        case 400: return .badRequest(data)
        case 401: return .unauthorized(data)
        case 403: return .forbidden(data)
        case 404: return .notFound(data)
        case 402, 405...499: return .error4xx(statusCode, data: data)
        case 500: return .serverError(data)
        case 501...599: return .error5xx(statusCode, data: data)
        default: return .unknownError(data)
        }
    }
    
    
    
    /// Parses URLSession Publisher errors and return proper ones
    /// - Parameter error: URLSession publisher error
    /// - Returns: Readable NWKNetworkRequestError
    private func handleError(_ error: Error) -> WKNetworkRequestError {
        switch error {
        case let error as DecodingError:
            return .decodingError(error.localizedDescription)
        case let error as URLError:
            return .urlSessionFailed(error)
        case let error as WKNetworkRequestError:
            return error
        default:
            return .unknownError()
        }
    }
    
    private func debugMessage(_ message: String) {
        #if DEBUG
            print("--- WK Request \(message)")
        #endif
    }
    
}
