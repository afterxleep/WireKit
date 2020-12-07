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
    }
        
    struct FindAll: WKRequest {
        typealias ReturnType = [Todo]
        var path: String = APIConstants.path
    }
    
    struct FindById: WKRequest {
        typealias ReturnType = [Todo]
        var path: String
        
        init(_ id: Int) {
            path = "\(APIConstants.path)/\(id)"
        }
    }
}
