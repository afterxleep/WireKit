//
//  WKAPIClientTests.swift
//  WireKit
//
//  Created by Daniel Bernal on 18/11/20.
//


import XCTest
import Combine
@testable import WireKit

final class WKAPIClientTests: XCTestCase {
    
    final class WKAPIClientTests: XCTestCase {
        
        func testRequest() async {
            guard let testData = TestHelpers.loadTestData(from: TestHelpers.TestPaths.todos) else {
                XCTFail()
                return
            }
            
            guard let url = URL(string: "\(TestHelpers.URLs.baseURL)") else {
                XCTFail()
                return
            }
            
            URLProtocolMock.requestHandler = { request in
                let response = HTTPURLResponse(url: url,
                                               statusCode: TestHelpers.HTTPSettings.httpSuccess,
                                               httpVersion: TestHelpers.HTTPSettings.httpVersion,
                                               headerFields: nil)!
                return (response, testData)
            }
            let dispatcher = WKNetworkDispatcher(urlSession: TestHelpers.DummyURLSession())
            let apiClient = WKAPIClient(baseURL: TestHelpers.URLs.baseURL, networkDispatcher: dispatcher)
            
            do {
                let _: [Todo] = try await apiClient.dispatch(Todo.API.FindAll())
                // If we reach this point, the request was successful
            } catch {
                XCTFail("Request failed with error: \(error)")
            }
        }
    }

    
}
