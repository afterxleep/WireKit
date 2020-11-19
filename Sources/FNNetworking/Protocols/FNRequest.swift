//
//  FNRequest.swift
//  FunctionalNetworking
//
//  Created by Daniel Bernal on 8/11/20.
//

import Foundation
import Combine

public typealias FNHTTPParams = [String: Any]
public typealias FNHTTPHeaders = [String: String]

public enum FNHTTPContentType: String {
    case json = "application/json"
}

public enum FNHTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

public enum FNHTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

public protocol FNRequest {
    associatedtype ReturnType: Codable
    var path: String { get }
    var method: FNHTTPMethod { get }
    var contentType: FNHTTPContentType { get }
    var params: FNHTTPParams? { get }
    var body: FNHTTPParams? { get }
    var headers: FNHTTPHeaders? { get }
}
 
extension FNRequest {
    
    // Defaults
    var method: FNHTTPMethod { return .get }
    var contentType: FNHTTPContentType { return .json }
    var params: FNHTTPParams? { return nil }
    var body: FNHTTPParams? { return nil }
    var headers: FNHTTPHeaders? { return nil }
    
}

// Utility Methods
extension FNRequest {
    
    /// Serializes an HTTP dictionary to a JSON Data Object
    /// - Parameter params: HTTP Parameters dictionary
    /// - Returns: Encoded JSON
    private func requestBodyFrom(params: FNHTTPParams?) -> Data? {
        guard let params = params else { return nil }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return nil
        }
        return httpBody
    }
    
    
    /// Generates a URLQueryItems array from a Params dictionary
    /// - Parameter params: HTTP Parameters dictionary
    /// - Returns: An Array of URLQueryItems
    private func queryItemsFrom(params: FNHTTPParams?) -> [URLQueryItem]? {
        guard let params = params else { return nil }
        return params.map {
            URLQueryItem(name: $0.key, value: $0.value as? String)
        }
    }
    
    /// Transforms an FNRequest into a standard URL request
    /// - Parameter baseURL: API Base URL to be used
    /// - Returns: A ready to use URLRequest
    func asURLRequest(baseURL: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        urlComponents.path = "\(urlComponents.path)\(path)"
        urlComponents.queryItems = queryItemsFrom(params: params)
        guard let finalURL = urlComponents.url else { return nil }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.httpBody = requestBodyFrom(params: body)
        let defaultHeaders: FNHTTPHeaders = [
            FNHTTPHeaderField.contentType.rawValue: contentType.rawValue,
            FNHTTPHeaderField.acceptType.rawValue: contentType.rawValue
        ]
        request.allHTTPHeaderFields = defaultHeaders.merging(headers ?? [:], uniquingKeysWith: { (first, _) in first })
        return request
    }
    
}

