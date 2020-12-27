#  Quick Start

### Define a Model, based on your Rest API

Define your model, make sure it conforms to Codable and it matches your API JSON structure.

``` swift
import Foundation

struct Todo: Codable, Identifiable {
    let userId: Int
    let id: Int?
    let title: String
    let completed: Bool
}
```

### Define a set of WireKit requests

All your REST API actions are defined using `WKRequest`.  You can also group multiple requests based on and endpoint or specific functionality.

Each request has it's own set of properties that you can define as needed.  (Incluiding Output Types, URL/Path, HTTPMethod, Body, Headers and more)

Here we are defining Find, Delete and Add requests for a simple Todo API.

``` swift
import WireKit

struct TodoAPI {
    private struct APIConstants {
        static var path = "/todos"
        static var root = "/"
    }
    
    // Find all Todo Items
    struct FindAll: WKRequest {
        typealias ReturnType = [Todo]
        var path: String = APIConstants.path
    }
    
    // Delete item with ID
    struct Delete: WKRequest {
        typealias ReturnType = Empty
        var path: String
        var method: WKHTTPMethod = .delete
        
        init(_ id: Int) {
            path = "\(APIConstants.path)/\(id)"
        }
    }
    
    // Adds a new Item
    struct Add: WKRequest {
        var path: String = APIConstants.path
        typealias ReturnType = Todo
        var method: WKHTTPMethod = .post
        var body: WKHTTPParams?        
        
        init(_ todoItem: Todo) {
            self.body = todoItem.asDictionary
        }
    }
}
```

### Setup your APIClient and Perform a request

Initialize your APIClient and use the internal `dispatch` function to dispatch a requests.

Since Wirekit relies on combine, and it automatically decodes API responses based on your defined Return Type, performin async requests is super simple.

``` swift

import Foundation
import WireKit
import Combine

class YourModel {
        
    private var apiClient: WKAPIClient
    private var cancellables = [AnyCancellable]()
    
    private enum Constants {
        static let apiURL = "https://jsonplaceholder.typicode.com"
    }
    
    init() {
        apiClient = WKAPIClient(baseURL: Constants.apiURL)
        loadData()
    }
    
    private func loadData() {
        
        // Perform a request from the TodoAPI
        // You can pass parameters and other data here.
        apiClient.dispatch(TodoAPI.FindAll())
            
            // Since we are displaying results in the UI, receive on Main Thread
            .receive(on: DispatchQueue.main)
            
            // Observe for Returned values
            .sink(
                receiveCompletion: { result in
                    
                    // Hide our loader on completion
                    self.isLoading = false
                    
                    // Act on when we get a result or failure
                    switch result {
                        case .failure(let error):
                            // Handle API response errors here (WKNetworkRequestError)
                            print("Error loading data: \(error)")
                        default: break
                    }
                },
                receiveValue: { value in                
                    // Do something with the received data here...
                    // ...                    
                })
            
            // Store the cancellable in a set (to hold a ref)
            .store(in: &cancellables)
    }
    
}

```
