//
//  FNAPIClientTests.swift
//  FNNetworking
//
//  Created by Daniel Bernal on 18/11/20.
//  © 2020 - Les Mobiles
//  MIT License
//


import XCTest
import Combine
@testable import FNNetworking

final class FNAPIClientTests: XCTestCase {
    
    private var cancellables = [AnyCancellable]()
    typealias ArrayPublisher = AnyPublisher<[Todo], FNNetworkRequestError>
    
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
        let dispatcher = FNNetworkDispatcher(urlSession: TestHelpers.DummyURLSession())
        let apiClient = FNAPIClient(baseURL: TestHelpers.URLs.baseURL, networkDispatcher: dispatcher)
        let expectation = XCTestExpectation(description: "Successful Data Load")
        let pub: ArrayPublisher = apiClient.dispatch(Todo.API.FindAll())
         pub            
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    expectation.fulfill()
                })
            .store(in: &cancellables)
        
    }
    
}
