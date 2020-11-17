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
    
    private var cancellables = [AnyCancellable]()
    
    enum TestData: String {
        case todos = "todos"
    }
    
    enum URLs: String {
        case baseURL = "https://jsonplaceholder.typicode.com/todos"
    }
    
    private func loadTestData(from data: TestData) -> Data? {
        guard let path = Bundle.module.path(forResource: data.rawValue, ofType: "json") else {
            XCTFail()
            return nil
        }
        do {
              let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
          } catch {
               return nil
          }
    }
    
    func testDispatcherSuccess() {
        
        let expectation = XCTestExpectation(description: "Successful Data Download")
        guard let url = URL(string: "\(URLs.baseURL.rawValue)") else {
            XCTFail()
            return
        }
        guard let testData: Data = loadTestData(from: TestData.todos) else {
            XCTFail()
            return
        }
                
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse.init(url: url, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            return (response, testData)
        }
        let urlSessionConfig = URLSessionConfiguration.ephemeral
        urlSessionConfig.protocolClasses = [URLProtocolMock.self]
        let urlSession = URLSession(configuration: urlSessionConfig)
        
        let request = URLRequest(url: url)        
        typealias Publisher = AnyPublisher<[Todo], NetworkRequestError>
        let pub: Publisher = FNNetworkDispatcher().dispatch(request: request,
                                                     decoder: JSONDecoder(),
                                                     urlSession: urlSession)
         pub
            .print()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    expectation.fulfill()
                })
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 1.0)
            
    }
    
    func testDispatcherError() {
        let expectation = XCTestExpectation(description: "Data download error (404)")
        guard let url = URL(string: "\(URLs.baseURL.rawValue)") else {
            XCTFail()
            return
        }
        
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse.init(url: url, statusCode: 404, httpVersion: "2.0", headerFields: nil)!
            return (response, Data())
        }
        let urlSessionConfig = URLSessionConfiguration.ephemeral
        urlSessionConfig.protocolClasses = [URLProtocolMock.self]
        
        let urlSession = URLSession(configuration: urlSessionConfig)
        let request = URLRequest(url: url)
        typealias Publisher = AnyPublisher<[Todo], NetworkRequestError>
        let pub: Publisher = FNNetworkDispatcher().dispatch(request: request,
                                                     decoder: JSONDecoder(),
                                                     urlSession: urlSession)
         pub
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    XCTAssertEqual(error, NetworkRequestError.notFound)
                    expectation.fulfill()
                default:
                    break
                }
            },
              receiveValue: {_ in })
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 1.0)
    }
}
