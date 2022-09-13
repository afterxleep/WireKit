//
//  TodoAPI.swift
//  WireKitSample
//
//  Created by Daniel Bernal on 6/12/20.
//

import Foundation
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
