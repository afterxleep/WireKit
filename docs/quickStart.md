#  Quick Start

### Define a Model, based on your Rest API

Define your models, make sure they conforms to Codable.

``` swift
// Basic Todo Model
struct Todo: Codable {
    let userId: Int
    let id: Int?
    let title: String
    let completed: Bool
}

// Empty Response Object -- To handle empty API responses
struct Empty: Codable {}
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
        // Return an array of 'Todo' items
        typealias ReturnType = [Todo]
        var path: String = APIConstants.path
    }
    
    // Delete item with ID
    struct Delete: WKRequest {
        // Return an Empty object
        typealias ReturnType = Empty
        var path: String
        var method: WKHTTPMethod = .delete
        
        init(_ id: Int) {
            // This translates into /todo/1
            path = "\(APIConstants.path)/\(id)"
        }
    }
    
    // Adds a new Item
    struct Add: WKRequest {
        var path: String = APIConstants.path
        // Return a single of 'Todo' items
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

Initialize your APIClient and use the internal `dispatch` function to dispatch a request.

Since Wirekit relies on Combine, and it automatically decodes API responses based on your defined Return Type, performing async API requests is super simple.

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
        // Initialize the API client
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

## More advanced stuff
For more advanced requests, incluiding Headers, Query parameters, and Body, checkout the [WKRequest documentation](wkrequest.md).
