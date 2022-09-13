//
//  WKSessionDispatcherTests.swift
//  WireKit
//
//  Created by Daniel Bernal on 16/11/20.
//


import XCTest
import Combine
@testable import WireKit

final class WKDispatcherTests: XCTestCase {
    
    typealias ArrayPublisher = AnyPublisher<[Todo], WKNetworkRequestError>
    private var cancellables = [AnyCancellable]()
    
    func testDispatcherSuccess() {
        
        let expectation = XCTestExpectation(description: "Successful Data Download")
        guard let url = URL(string: "\(TestHelpers.URLs.baseURL)") else {
            XCTFail()
            return
        }
        guard let testData = TestHelpers.loadTestData(from: TestHelpers.TestPaths.todos) else {
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
        let request = URLRequest(url: url)
        let arrayPublisher: ArrayPublisher = dispatcher.dispatch(request: request, decoder: JSONDecoder())
        arrayPublisher.sink(receiveCompletion: { _ in },
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
        let dispatcher = WKNetworkDispatcher(urlSession: TestHelpers.DummyURLSession())
        let request = URLRequest(url: url)
        let arrayPublisher: ArrayPublisher = dispatcher.dispatch(request: request, decoder: JSONDecoder())
        arrayPublisher.sink(receiveCompletion: { result in
            switch result {
                case .failure(let error):
                    XCTAssertEqual(error, WKNetworkRequestError.notFound(Data()))
                    expectation.fulfill()
                default:
                    break
                }
            },
            receiveValue: {_ in })
        .store(in: &cancellables)
        wait(for: [expectation], timeout: TestHelpers.HTTPSettings.requestTimeout)
    }
    
    func testDispatcherErrorWithData() {
        let expectation = XCTestExpectation(description: "Data download error (404)")
        guard let url = URL(string: "\(TestHelpers.URLs.baseURL)") else {
            XCTFail()
            return
        }
        
        guard let testData = TestHelpers.loadTestData(from: TestHelpers.TestPaths.todo) else {
            XCTFail()
            return
        }
        
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse.init(url: url,
                                                statusCode: TestHelpers.HTTPSettings.httpError,
                                                httpVersion: TestHelpers.HTTPSettings.httpVersion,
                                                headerFields: nil)!
            return (response, testData)
        }
        let dispatcher = WKNetworkDispatcher(urlSession: TestHelpers.DummyURLSession())
        let request = URLRequest(url: url)
        let arrayPublisher: ArrayPublisher = dispatcher.dispatch(request: request, decoder: JSONDecoder())
        arrayPublisher.sink(receiveCompletion: { result in
            switch result {
                case .failure(let error):
                XCTAssertEqual(error, WKNetworkRequestError.error4xx(409, data: testData))
                    expectation.fulfill()
                default:
                    break
                }
            },
            receiveValue: {_ in })
        .store(in: &cancellables)
        wait(for: [expectation], timeout: TestHelpers.HTTPSettings.requestTimeout)
    }
    
    func testDispatcherDecodingMalformedError() {
        let expectation = XCTestExpectation(description: "Data decoding error")
        guard let url = URL(string: "\(TestHelpers.URLs.baseURL)") else {
            XCTFail()
            return
        }
        
        guard let testData = TestHelpers.loadTestData(from: TestHelpers.TestPaths.malformed) else {
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
        let request = URLRequest(url: url)
        let arrayPublisher: ArrayPublisher = dispatcher.dispatch(request: request, decoder: JSONDecoder())
        arrayPublisher.sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTAssertEqual(error, WKNetworkRequestError.decodingError("The data couldn’t be read because it isn’t in the correct format."))
                    expectation.fulfill()
                default:
                    break
                }
            },
            receiveValue: {_ in })
        .store(in: &cancellables)
        wait(for: [expectation], timeout: TestHelpers.HTTPSettings.requestTimeout)
    }
    
    func testDispatcherDecodingInvalidData() {
        let expectation = XCTestExpectation(description: "Data decoding error")
        guard let url = URL(string: "\(TestHelpers.URLs.baseURL)") else {
            XCTFail()
            return
        }
        
        guard let testData = TestHelpers.loadTestData(from: TestHelpers.TestPaths.incorrect_format) else {
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
        let request = URLRequest(url: url)
        let arrayPublisher: ArrayPublisher = dispatcher.dispatch(request: request, decoder: JSONDecoder())
        arrayPublisher.sink(receiveCompletion: { result in
            switch result {
                case .failure(let error):
                    XCTAssertEqual(error, WKNetworkRequestError.decodingError("The data couldn’t be read because it isn’t in the correct format."))
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
