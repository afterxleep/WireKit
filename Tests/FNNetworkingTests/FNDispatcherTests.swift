//
//  URLSessionDispatcherTests.swift
//  
//
//  Created by Daniel Bernal on 16/11/20.
//

import XCTest
import Combine
@testable import FNNetworking

final class FNDispatcherTests: XCTestCase {
    
    typealias ArrayPublisher = AnyPublisher<[Todo], FNNetworkRequestError>
    private var cancellables = [AnyCancellable]()
    
    func testDispatcherSuccess() {
        
        let expectation = XCTestExpectation(description: "Successful Data Download")
        guard let url = URL(string: "\(TestHelpers.URLs.baseURL)") else {
            XCTFail()
            return
        }
        guard let testData: Data = TestHelpers.loadTestData(from: TestHelpers.TestPaths.todos) else {
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
        let request = URLRequest(url: url)
        let pub: ArrayPublisher = dispatcher.dispatch(request: request)
         pub
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    expectation.fulfill()
                })
            .store(in: &cancellables)
        wait(for: [expectation], timeout: TestHelpers.HTTPSettings.requestTimeout)
            
    }
    
    func testDispatcherError() {
        let expectation = XCTestExpectation(description: "Data download error (404)")
        guard let url = URL(string: "\(TestHelpers.URLs.baseURL)") else {
            XCTFail()
            return
        }
        
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse.init(url: url,
                                                statusCode: TestHelpers.HTTPSettings.httpnotFound,
                                                httpVersion: TestHelpers.HTTPSettings.httpVersion,
                                                headerFields: nil)!
            return (response, Data())
        }
        let dispatcher = FNNetworkDispatcher(urlSession: TestHelpers.DummyURLSession())
        let request = URLRequest(url: url)
        let pub: ArrayPublisher = dispatcher.dispatch(request: request)
         pub
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTAssertEqual(error, FNNetworkRequestError.notFound)
                    expectation.fulfill()
                default:
                    break
                }
            },
              receiveValue: {_ in })
            .store(in: &cancellables)
        wait(for: [expectation], timeout: TestHelpers.HTTPSettings.requestTimeout)
    }
    
    func testDispatcherDecodingError() {
        let expectation = XCTestExpectation(description: "Data decoding error")
        guard let url = URL(string: "\(TestHelpers.URLs.baseURL)") else {
            XCTFail()
            return
        }
        
        guard let testData: Data = TestHelpers.loadTestData(from: TestHelpers.TestPaths.todo) else {
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
        let request = URLRequest(url: url)
        let pub: ArrayPublisher = dispatcher.dispatch(request: request)
         pub
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTAssertEqual(error, FNNetworkRequestError.decodingError)
                    expectation.fulfill()
                default:
                    break
                }
            },
              receiveValue: {_ in })
            .store(in: &cancellables)
        wait(for: [expectation], timeout: TestHelpers.HTTPSettings.requestTimeout)
    }
}
