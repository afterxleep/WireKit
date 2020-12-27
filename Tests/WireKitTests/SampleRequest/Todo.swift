//
//  Todo.swift
//  WireKit
//
//  Created by Daniel Bernal on 8/11/20.
//


import Foundation
@testable import WireKit

struct Todo: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
    
    struct API {
        private struct APIConstants {
            static var path = "/todos"
            static var headers = ["header1": "value1", "header2": "value2"]
            static var queryParams = ["param1": "value1", "param2": "value2"]
        }
            
        struct FindAll: WKRequest {
            typealias ReturnType = [Todo]
            var path: String = APIConstants.path
            var headers: WKHTTPHeaders? = APIConstants.headers
            var queryParams: WKHTTPParams? = APIConstants.queryParams
        }
        
        struct FindById: WKRequest {
            typealias ReturnType = [Todo]
            var path: String
            var headers: WKHTTPHeaders? = APIConstants.headers
            var queryParams: WKHTTPParams? = APIConstants.queryParams
            
            init(_ id: Int) {
                path = "\(APIConstants.path)/\(id)"
            }
        }
        
        struct Add: WKRequest {
            typealias ReturnType = Todo
            var path: String = APIConstants.path
            var body: WKHTTPParams?
            var method: WKHTTPMethod = .post
            var headers: WKHTTPHeaders? = APIConstants.headers
            var queryParams: WKHTTPParams? = APIConstants.queryParams
            
            init(_ todo: Todo) {
                body = todo.asDictionary
            }
        }
        
        struct Delete: WKRequest {
            typealias ReturnType = Todo
            var path: String
            var method: WKHTTPMethod = .delete
            var headers: WKHTTPHeaders? = APIConstants.headers
            var queryParams: WKHTTPParams? = APIConstants.queryParams
            
            init(_ todo: Todo) {
                path = "\(APIConstants.path)/\(todo.id)"
            }
        }
        
        struct Update: WKRequest {
            typealias ReturnType = Todo
            var path: String = APIConstants.path
            var body: WKHTTPParams?
            var method: WKHTTPMethod = .put
            var headers: WKHTTPHeaders? = APIConstants.headers
            var queryParams: WKHTTPParams? = APIConstants.queryParams
            
            init(_ todo: Todo) {
                path = "\(APIConstants.path)/\(todo.id)"
                body = todo.asDictionary
            }
        }
        
    }
}


