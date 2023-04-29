//
//  TodoListViewModelTests.swift
//  WireKitSample
//
//  Created by Daniel on 29/04/23.
//

import Foundation
import XCTest
import Combine
import WireKit
@testable import WireKitSample

class TodoListViewModelTests: XCTestCase {

    private var todoItemsCancellable: AnyCancellable?

    func testListModelWorks() {

        // Note that we're using non SSL urls here as URLProtocol does
        // to avoid SSL errors in URLSession
        let url = URL(string: "http://jsonplaceholder.typicode.com/todos")

        // Get some test data from a file
        do {
            let jsonData = try loadJSONDataFromFile(named: "todoItems")
            URLProtocolMock.testURLs = [url: jsonData]
        } catch {
            XCTFail("Error loading JSON data: \(error)")
        }

        // Use the Mock
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]

        // Create a custom URL Session
        let session = URLSession(configuration: config)

        // Initialize the APIClient and pass along a custom dispatcher
        // Note that we're using non SSL urls here as 
        let baseURL = "http://jsonplaceholder.typicode.com"

        // Then
        let dispatcher = WKNetworkDispatcher(urlSession: session)
        let apiClient = WKAPIClient(baseURL: baseURL, networkDispatcher: dispatcher)

        let expectation = XCTestExpectation(description: "Wait for the response")
        let model = TodoListViewModel(apiClient: apiClient)
        todoItemsCancellable = model.$todoItems
            .dropFirst() // To skip the initial (empty) value
            .sink { todoItems in
                XCTAssertGreaterThan(todoItems.count, 0, "Todo items should be loaded")
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 10)
    }

    deinit {
        todoItemsCancellable?.cancel()
    }

}

