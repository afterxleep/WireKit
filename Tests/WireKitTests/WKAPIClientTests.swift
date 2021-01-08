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
    
    private var cancellables = [AnyCancellable]()
    typealias ArrayPublisher = AnyPublisher<[Todo], WKNetworkRequestError>
    
    func testRequest() {
        
        guard let testData = TestHelpers.loadTestData(from: TestHelpers.TestPaths.todos) else {
            XCTFail()
            return
        }
        
        guard let url = URL(string: "\(TestHelpers.URLs.baseURL)") else {
            XCTFail()
            return
        }
        
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse.init(url: url,
                                                statusCode: TestHelpers.HTTPSettings.httpSuccess,
                                                httpVersion: TestHelpers.HTTPSettings.httpVersion,
                                                headerFields: nil)!
            return (response, testData)
        }
        let dispatcher = WKNetworkDispatcher(urlSession: TestHelpers.DummyURLSession())
        let apiClient = WKAPIClient(baseURL: TestHelpers.URLs.baseURL, networkDispatcher: dispatcher)
        let expectation = XCTestExpectation(description: "Successful Data Load")
        let arrayPublisher: ArrayPublisher = apiClient.dispatch(Todo.API.FindAll())
        arrayPublisher
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    expectation.fulfill()
                })
            .store(in: &cancellables)
        
    }
    
}
