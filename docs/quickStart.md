# Quick Start

### Define a Model, Based on Your REST API

Define your models, ensuring they conform to the Codable protocol.

```swift
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

### Define a Set of WireKit Requests
Your REST API actions are defined using WKRequest. You can also group multiple requests based on an endpoint or specific functionality.

Each request has its own set of properties that you can define as needed (including Output Types, URL/Path, HTTPMethod, Body, Headers, and more).

Here, we are defining Find, Delete, and Add requests for a simple Todo API.

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
        // Return a single 'Todo' item
        typealias ReturnType = Todo
        var method: WKHTTPMethod = .post
        var body: WKHTTPParams?
        
        init(_ todoItem: Todo) {
            self.body = todoItem.asDictionary
        }
    }
}

```

### Setup Your APIClient and Perform a Request

Initialize your APIClient and use the internal dispatch function to dispatch a request.

With WireKit's migration to async/await, performing asynchronous API requests is even more streamlined, providing a clear and concise way to handle API calls and responses.

``` swift

import Foundation
import WireKit

class YourModel {
        
    private var apiClient: WKAPIClient
    
    private enum Constants {
        static let apiURL = "https://jsonplaceholder.typicode.com"
    }
    
    init() {
        // Initialize the API client
        apiClient = WKAPIClient(baseURL: Constants.apiURL)
        Task {
            await loadData()
        }
    }
    
    private func loadData() async {
        
        // Perform a request from the TodoAPI
        do {
            let todos: [Todo] = try await apiClient.dispatch(TodoAPI.FindAll())
            // Process todos...
        } catch {
            // Handle API response errors here (WKNetworkRequestError)
            print("Error loading data: \(error)")
        }
    }
    
}

```

## More advanced stuff
For more advanced requests, incluiding Headers, Query parameters, and Body, checkout the [WKRequest documentation](wkrequest.md).
