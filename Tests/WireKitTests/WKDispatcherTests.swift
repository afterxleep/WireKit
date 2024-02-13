//
//  WKSessionDispatcherTests.swift
//  WireKit
//
//  Created by Daniel Bernal on 16/11/20.
//


import XCTest
@testable import WireKit

final class WKDispatcherTests: XCTestCase {
    
    // Test for successful data download
    func testDispatcherSuccess() async {
        guard let url = URL(string: "\(TestHelpers.URLs.baseURL)"),
              let testData = TestHelpers.loadTestData(from: TestHelpers.TestPaths.todos) else {
            XCTFail("Setup failed")
            return
        }
                
        URLProtocolMock.requestHandler = { _ in
            let response = HTTPURLResponse(url: url,
                                           statusCode: TestHelpers.HTTPSettings.httpSuccess,
                                           httpVersion: TestHelpers.HTTPSettings.httpVersion,
                                           headerFields: nil)!
            return (response, testData)
        }
        
        let dispatcher = WKNetworkDispatcher(urlSession: TestHelpers.DummyURLSession())
        let request = URLRequest(url: url)
        
        do {
            let _: [Todo] = try await dispatcher.dispatch(request: request, decoder: JSONDecoder())
            // Assert for successful response here
        } catch {
            XCTFail("Request failed with error: \(error)")
        }
    }

    // Test for 404 error
    func testDispatcherError() async {
        guard let url = URL(string: "\(TestHelpers.URLs.baseURL)") else {
            XCTFail("URL setup failed")
            return
        }
        
        URLProtocolMock.requestHandler = { _ in
            let response = HTTPURLResponse(url: url,
                                           statusCode: TestHelpers.HTTPSettings.httpnotFound,
                                           httpVersion: TestHelpers.HTTPSettings.httpVersion,
                                           headerFields: nil)!
            return (response, Data())
        }
        
        let dispatcher = WKNetworkDispatcher(urlSession: TestHelpers.DummyURLSession())
        let request = URLRequest(url: url)
        
        do {
            let _: [Todo] = try await dispatcher.dispatch(request: request, decoder: JSONDecoder())
            XCTFail("Expected failure, but request succeeded")
        } catch let error as WKNetworkRequestError {
            XCTAssertEqual(error, WKNetworkRequestError.notFound(Data()))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    // Test for 409 error with data
    func testDispatcherErrorWithData() async {
        guard let url = URL(string: "\(TestHelpers.URLs.baseURL)"),
              let testData = TestHelpers.loadTestData(from: TestHelpers.TestPaths.todo) else {
            XCTFail("Setup failed")
            return
        }

        URLProtocolMock.requestHandler = { _ in
            let response = HTTPURLResponse(url: url,
                                           statusCode: TestHelpers.HTTPSettings.httpError,
                                           httpVersion: TestHelpers.HTTPSettings.httpVersion,
                                           headerFields: nil)!
            return (response, testData)
        }

        let dispatcher = WKNetworkDispatcher(urlSession: TestHelpers.DummyURLSession())
        let request = URLRequest(url: url)

        do {
            let _: [Todo] = try await dispatcher.dispatch(request: request, decoder: JSONDecoder())
            XCTFail("Expected failure, but request succeeded")
        } catch let error as WKNetworkRequestError {
            XCTAssertEqual(error, WKNetworkRequestError.error4xx(409, data: testData))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    // Test for malformed data error
    func testDispatcherDecodingMalformedError() async {
        guard let url = URL(string: "\(TestHelpers.URLs.baseURL)"),
              let testData = TestHelpers.loadTestData(from: TestHelpers.TestPaths.malformed) else {
            XCTFail("Setup failed")
            return
        }

        URLProtocolMock.requestHandler = { _ in
            let response = HTTPURLResponse(url: url,
                                           statusCode: TestHelpers.HTTPSettings.httpSuccess,
                                           httpVersion: TestHelpers.HTTPSettings.httpVersion,
                                           headerFields: nil)!
            return (response, testData)
        }

        let dispatcher = WKNetworkDispatcher(urlSession: TestHelpers.DummyURLSession())
        let request = URLRequest(url: url)

        do {
            let _: [Todo] = try await dispatcher.dispatch(request: request, decoder: JSONDecoder())
            XCTFail("Expected decoding failure, but request succeeded")
        } catch let error as WKNetworkRequestError {
            XCTAssertEqual(error, WKNetworkRequestError.decodingError("The data couldn’t be read because it isn’t in the correct format."))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    // Test for invalid data error
    func testDispatcherDecodingInvalidData() async {
        guard let url = URL(string: "\(TestHelpers.URLs.baseURL)"),
              let testData = TestHelpers.loadTestData(from: TestHelpers.TestPaths.incorrect_format) else {
            XCTFail("Setup failed")
            return
        }

        URLProtocolMock.requestHandler = { _ in
            let response = HTTPURLResponse(url: url,
                                           statusCode: TestHelpers.HTTPSettings.httpSuccess,
                                           httpVersion: TestHelpers.HTTPSettings.httpVersion,
                                           headerFields: nil)!
            return (response, testData)
        }

        let dispatcher = WKNetworkDispatcher(urlSession: TestHelpers.DummyURLSession())
        let request = URLRequest(url: url)

        do {
            let _: [Todo] = try await dispatcher.dispatch(request: request, decoder: JSONDecoder())
            XCTFail("Expected decoding failure, but request succeeded")
        } catch let error as WKNetworkRequestError {
            XCTAssertEqual(error, WKNetworkRequestError.decodingError("The data couldn’t be read because it isn’t in the correct format."))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

}

