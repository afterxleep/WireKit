//
//  WKRequest.swift
//  FunctionalNetworking
//
//  Created by Daniel Bernal on 8/11/20.
//

import Foundation
import Combine

public typealias WKHTTPParams = [String: Any]
public typealias WKHTTPHeaders = [String: String]

public enum WKHTTPContentType: String {
    case json = "application/json"
}

public enum WKHTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

public enum WKHTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

public protocol WKRequest {
    associatedtype ReturnType: Codable
    var path: String { get }
    var method: WKHTTPMethod { get }
    var contentType: WKHTTPContentType { get }
    var queryParams: WKHTTPParams? { get }
    var body: WKHTTPParams? { get }
    var headers: WKHTTPHeaders? { get }
    var decoder: JSONDecoder? { get }
}
 
public extension WKRequest {
    
    // Defaults
    var method: WKHTTPMethod { return .get }
    var contentType: WKHTTPContentType { return .json }
    var queryParams: WKHTTPParams? { return nil }
    var body: WKHTTPParams? { return nil }
    var headers: WKHTTPHeaders? { return nil }
    var debug: Bool { return false }
    
}

// Utility Methods
extension WKRequest {
    
    /// Serializes an HTTP dictionary to a JSON Data Object
    /// - Parameter params: HTTP Parameters dictionary
    /// - Returns: Encoded JSON
    private func requestBodyFrom(params: WKHTTPParams?) -> Data? {
        guard let params = params else { return nil }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return nil
        }
        return httpBody
    }
    
    
    /// Generates a URLQueryItems array from a Params dictionary
    /// - Parameter params: HTTP Parameters dictionary
    /// - Returns: An Array of URLQueryItems
    private func queryItemsFrom(params: WKHTTPParams?) -> [URLQueryItem]? {
        guard let params = params else { return nil }
        return params.map {
            URLQueryItem(name: $0.key, value: $0.value as? String)
        }
    }
    
    /// Transforms an WKRequest into a standard URL request
    /// - Parameter baseURL: API Base URL to be used
    /// - Returns: A ready to use URLRequest
    func asURLRequest(baseURL: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        urlComponents.path = "\(urlComponents.path)\(path)"
        urlComponents.queryItems = queryItemsFrom(params: queryParams)
        guard let finalURL = urlComponents.url else { return nil }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.httpBody = requestBodyFrom(params: body)
        let defaultHeaders: WKHTTPHeaders = [
            WKHTTPHeaderField.contentType.rawValue: contentType.rawValue,
            WKHTTPHeaderField.acceptType.rawValue: contentType.rawValue
        ]
        request.allHTTPHeaderFields = defaultHeaders.merging(headers ?? [:], uniquingKeysWith: { (first, _) in first })
        return request
    }
    
}

