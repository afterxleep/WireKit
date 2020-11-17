//
//  Request.swift
//  FunctionalNetworking
//
//  Created by Daniel Bernal on 8/11/20.
//

import Foundation
import Combine

typealias HTTPParams = [String: Any]
typealias HTTPHeaders = [String: String]

enum HTTPContentType: String {
    case json = "application/json"
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

protocol FNRequest {
    associatedtype ReturnType: Codable
    var path: String { get }
    var method: HTTPMethod { get }
    var contentType: HTTPContentType { get }
    var params: HTTPParams? { get }
    var body: HTTPParams? { get }
    var headers: HTTPHeaders? { get }
}
 
extension FNRequest {
    
    // Defaults
    var method: HTTPMethod { return .get }
    var contentType: HTTPContentType { return .json }
    var params: HTTPParams? { return nil }
    var body: HTTPParams? { return nil }
    var headers: HTTPHeaders? { return nil }
    
}

// Utility Methods
extension FNRequest {
    
    private func requestBodyFrom(params: HTTPParams?) -> Data? {
        guard let params = params else { return nil }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return nil
        }
        return httpBody
    }
    
    private func queryItemsFrom(params: HTTPParams?) -> [URLQueryItem]? {
        guard let params = params else { return nil }
        return params.map {
            URLQueryItem(name: $0.key, value: $0.value as? String)
        }
    }
    
    func asURLRequest(baseURL: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        urlComponents.path = "\(urlComponents.path)\(path)"
        urlComponents.queryItems = queryItemsFrom(params: params)
        guard let finalURL = urlComponents.url else { return nil }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.httpBody = requestBodyFrom(params: body)
        let defaultHeaders: HTTPHeaders = [
            HTTPHeaderField.contentType.rawValue: contentType.rawValue,
            HTTPHeaderField.acceptType.rawValue: contentType.rawValue
        ]
        request.allHTTPHeaderFields = defaultHeaders.merging(headers ?? [:], uniquingKeysWith: { (first, _) in first })
        return request
    }
    
}

