//
//  TestHelpers.swift
//  FNNetworking
//
//  Created by Daniel Bernal on 18/11/20.
//  © 2020 - Les Mobiles
//  MIT License
//


import XCTest
import Foundation

struct TestHelpers {
    
    enum TestPaths: String {
        case todos
        case todo
    }
    
    enum URLs {
        static let baseURL = "https://jsonplaceholder.typicode.com/todos"
    }
    
    enum HTTPSettings {
        static let httpVersion = "2.0"
        static let httpSuccess = 200
        static let httpnotFound = 404
        static let requestTimeout = 1.0
    }
    
    static func loadTestData(from data: TestPaths) -> Data? {
        guard let path = Bundle.module.path(forResource: data.rawValue, ofType: "json") else {
            return nil
        }
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
          } catch {
            return nil
          }
    }
    
    static func DummyURLSession() -> URLSession {
        let urlSessionConfig = URLSessionConfiguration.ephemeral
        urlSessionConfig.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: urlSessionConfig)
    }
}
