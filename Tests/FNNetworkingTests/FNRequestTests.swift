//
//  FNRequestRests.swift
//  FunctionalNetworking
//
//  Created by Daniel Bernal on 8/11/20.
//

import XCTest
import Combine
@testable import FNNetworking

final class FNRequestTests: XCTestCase {
    
    enum Constants {
        static let testURL = "http://google.com"
        static let getPath = "/todos/1"
        static let postPath = "/todos"
        static let testTodo = Todo(userId: 1, id: 1, title: "Testing 123", completed: true)
        
        enum TestData {
            static let params1 = "param1=value1"
            static let params2 = "param2=value2"
            static let contentType = ("Content-Type", "application/json")
            static let accept = ("Accept", "application/json")
            static let header1 = ("header1", "value1")
            static let header2 = ("header2", "value2")
        }
    }
    
    func testGetRequest() {
        guard let requestCfg = Todo.API.FindById(1).asURLRequest(baseURL: Constants.testURL) else {
            XCTFail()
            return
        }
        let url = requestURL(request: requestCfg)
        generalTests(url: url, request: requestCfg)
        XCTAssertTrue(url.starts(with: "\(Constants.testURL)\(Constants.getPath)"))
        XCTAssertTrue(FNHTTPMethod(rawValue: requestCfg.httpMethod ?? "") == FNHTTPMethod.get)
    }
    
    func testDeleteRequest() {
        guard let request = Todo.API.Delete(Constants.testTodo).asURLRequest(baseURL: Constants.testURL) else {
            XCTFail()
            return
        }
        let url = requestURL(request: request)
        generalTests(url: url, request: request)
        XCTAssertTrue(url.starts(with: "\(Constants.testURL)\(Constants.getPath)"))
        XCTAssertTrue(FNHTTPMethod(rawValue: request.httpMethod ?? "") == FNHTTPMethod.delete)
    }
    
    
    func testPostRequest() {
        guard let request = Todo.API.Add(Constants.testTodo).asURLRequest(baseURL: Constants.testURL) else {
            XCTFail()
            return
        }
        let url = requestURL(request: request)
        XCTAssertTrue(url.starts(with: "\(Constants.testURL)\(Constants.postPath)"))
        XCTAssertTrue(FNHTTPMethod(rawValue: request.httpMethod ?? "") == FNHTTPMethod.post)
        bodyTests(request: request)
        generalTests(url: url, request: request)
    }
    
    func testPutRequest() {
        guard let request = Todo.API.Update(Constants.testTodo).asURLRequest(baseURL: Constants.testURL) else {
            XCTFail()
            return
        }
        let url = requestURL(request: request)
        XCTAssertTrue(url.starts(with: "\(Constants.testURL)\(Constants.postPath)"))
        XCTAssertTrue(FNHTTPMethod(rawValue: request.httpMethod ?? "") == FNHTTPMethod.put)
        bodyTests(request: request)
        generalTests(url: url, request: request)
    }
    
    
    private func bodyTests(request: URLRequest) {
        guard let requestBody = request.httpBody else {
            XCTFail()
            return
        }
        let decodedBody = try? JSONDecoder().decode(Todo.self, from: requestBody)
        XCTAssertTrue(decodedBody?.id == Constants.testTodo.id)
        XCTAssertTrue(decodedBody?.userId == Constants.testTodo.userId)
        XCTAssertTrue(decodedBody?.title == Constants.testTodo.title)
        XCTAssertTrue(decodedBody?.completed == Constants.testTodo.completed)
    }
    
    private func requestURL(request: URLRequest) -> String {
        return request.url?.absoluteString ?? ""
    }
    
    private func generalTests(url: String, request: URLRequest) {
        XCTAssertTrue(url.contains(Constants.TestData.params1))
        XCTAssertTrue(url.contains(Constants.TestData.params2))
        XCTAssertTrue(request.allHTTPHeaderFields?[Constants.TestData.contentType.0] == Constants.TestData.contentType.1)
        XCTAssertTrue(request.allHTTPHeaderFields?[Constants.TestData.accept.0] == Constants.TestData.accept.1)
        XCTAssertTrue(request.allHTTPHeaderFields?[Constants.TestData.header1.0] == Constants.TestData.header1.1)
        XCTAssertTrue(request.allHTTPHeaderFields?[Constants.TestData.header2.0] == Constants.TestData.header2.1)
    }
}
