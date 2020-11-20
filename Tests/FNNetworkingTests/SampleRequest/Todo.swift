//
//  Todo.swift
//  FNNetworking
//
//  Created by Daniel Bernal on 8/11/20.
//  © 2020 - Les Mobiles
//  MIT License
//


import Foundation
@testable import FNNetworking

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
            
        struct FindAll: FNRequest {
            typealias ReturnType = [Todo]
            var path: String = APIConstants.path
            var headers: FNHTTPHeaders? = APIConstants.headers
            var queryParams: FNHTTPParams? = APIConstants.queryParams
        }
        
        struct FindById: FNRequest {
            typealias ReturnType = [Todo]
            var path: String
            var headers: FNHTTPHeaders? = APIConstants.headers
            var queryParams: FNHTTPParams? = APIConstants.queryParams
            
            init(_ id: Int) {
                path = "\(APIConstants.path)/\(id)"
            }
        }
        
        struct Add: FNRequest {
            typealias ReturnType = Todo
            var path: String = APIConstants.path
            var body: FNHTTPParams?
            var method: FNHTTPMethod = .post
            var headers: FNHTTPHeaders? = APIConstants.headers
            var queryParams: FNHTTPParams? = APIConstants.queryParams
            
            init(_ todo: Todo) {
                body = todo.asDictionary
            }
        }
        
        struct Delete: FNRequest {
            typealias ReturnType = Todo
            var path: String
            var method: FNHTTPMethod = .delete
            var headers: FNHTTPHeaders? = APIConstants.headers
            var queryParams: FNHTTPParams? = APIConstants.queryParams
            
            init(_ todo: Todo) {
                path = "\(APIConstants.path)/\(todo.id)"
            }
        }
        
        struct Update: FNRequest {
            typealias ReturnType = Todo
            var path: String = APIConstants.path
            var body: FNHTTPParams?
            var method: FNHTTPMethod = .put
            var headers: FNHTTPHeaders? = APIConstants.headers
            var queryParams: FNHTTPParams? = APIConstants.queryParams
            
            init(_ todo: Todo) {
                path = "\(APIConstants.path)/\(todo.id)"
                body = todo.asDictionary
            }
        }
        
    }
}

