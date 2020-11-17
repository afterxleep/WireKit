//
//  APIRequestRests.swift
//  FunctionalNetworking
//
//  Created by Daniel Bernal on 8/11/20.
//

import XCTest
import Combine
@testable import FNNetworking

final class FNRequestTests: XCTestCase {
    
    static let testURL = "http://google.com"
    static let testTodo = Todo(userId: 1, id: 1, title: "Testing 123", completed: true)
    
    func testGetRequest() {
        guard let requestCfg = Todo.API.FindById(1).asURLRequest(baseURL: Self.testURL) else {
            XCTFail()
            return
        }
        let url = requestURL(request: requestCfg)
        generalTests(url: url, request: requestCfg)
        XCTAssertTrue(url.starts(with: "\(Self.testURL)/todos/1"))
        XCTAssertTrue(HTTPMethod(rawValue: requestCfg.httpMethod ?? "") == HTTPMethod.get)
    }
    
    func testDeleteRequest() {
        guard let request = Todo.API.Delete(Self.testTodo).asURLRequest(baseURL: Self.testURL) else {
            XCTFail()
            return
        }
        let url = requestURL(request: request)
        generalTests(url: url, request: request)
        XCTAssertTrue(url.starts(with: "\(Self.testURL)/todos/1"))
        XCTAssertTrue(HTTPMethod(rawValue: request.httpMethod ?? "") == HTTPMethod.delete)
    }
    
    
    func testPostRequest() {
        guard let request = Todo.API.Add(Self.testTodo).asURLRequest(baseURL: Self.testURL) else {
            XCTFail()
            return
        }
        let url = requestURL(request: request)
        XCTAssertTrue(url.starts(with: "\(Self.testURL)/todos"))
        XCTAssertTrue(HTTPMethod(rawValue: request.httpMethod ?? "") == HTTPMethod.post)
        bodyTests(request: request)
        generalTests(url: url, request: request)
    }
    
    func testPutRequest() {
        guard let request = Todo.API.Update(Self.testTodo).asURLRequest(baseURL: Self.testURL) else {
            XCTFail()
            return
        }
        let url = requestURL(request: request)
        XCTAssertTrue(url.starts(with: "\(Self.testURL)/todos"))
        XCTAssertTrue(HTTPMethod(rawValue: request.httpMethod ?? "") == HTTPMethod.put)
        bodyTests(request: request)
        generalTests(url: url, request: request)
    }
    
    
    private func bodyTests(request: URLRequest) {
        guard let requestBody = request.httpBody else {
            XCTFail()
            return
        }
        let decodedBody = try? JSONDecoder().decode(Todo.self, from: requestBody)
        XCTAssertTrue(decodedBody?.id == Self.testTodo.id)
        XCTAssertTrue(decodedBody?.userId == Self.testTodo.userId)
        XCTAssertTrue(decodedBody?.title == Self.testTodo.title)
        XCTAssertTrue(decodedBody?.completed == Self.testTodo.completed)
    }
    
    private func requestURL(request: URLRequest) -> String {
        return request.url?.absoluteString ?? ""
    }
    
    private func generalTests(url: String, request: URLRequest) {
        XCTAssertTrue(url.contains("param1=value1"))
        XCTAssertTrue(url.contains("param2=value2"))
        XCTAssertTrue(request.allHTTPHeaderFields?["Content-Type"] == "application/json")
        XCTAssertTrue(request.allHTTPHeaderFields?["Accept"] == "application/json")
        XCTAssertTrue(request.allHTTPHeaderFields?["Accept"] == "application/json")
        XCTAssertTrue(request.allHTTPHeaderFields?["header1"] == "value1")
        XCTAssertTrue(request.allHTTPHeaderFields?["header2"] == "value2")
    }
}
