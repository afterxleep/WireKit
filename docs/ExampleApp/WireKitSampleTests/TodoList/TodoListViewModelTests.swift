//
//  TodoListViewModelTests.swift
//  WireKitSample
//
//  Created by Daniel on 29/04/23.
//

import Foundation
import XCTest
@testable import WireKitSample

class TodoListViewModelTests: XCTestCase {

    func testListModelWorks() async {
        // Note that we're using non SSL urls here as URLProtocol does
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")

        // Get some test data from a file
        do {
            let jsonData = try loadJSONDataFromFile(named: "todoItems")
            URLProtocolMock.testURLs = [url: jsonData]
        } catch {
            XCTFail("Error loading JSON data: \(error)")
            return
        }

        // Use the Mock
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]

        // Create a custom URL Session
        let session = URLSession(configuration: config)

        // Initialize the APIClient and pass along a custom dispatcher
        let baseURL = "https://jsonplaceholder.typicode.com"
        let dispatcher = WKNetworkDispatcher(urlSession: session)
        let apiClient = WKAPIClient(baseURL: baseURL, networkDispatcher: dispatcher)

        let model = TodoListViewModel(apiClient: apiClient)

        // Wait for the model to load data
        let expectation = XCTestExpectation(description: "Wait for the response")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertGreaterThan(model.todoItems.count, 0, "Todo items should be loaded")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
}
