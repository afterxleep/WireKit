//
//  TestHelpers.swift
//  WireKitSample
//
//  Created by Daniel on 29/04/23.
//


import XCTest

extension XCTestCase {
    func loadJSONDataFromFile(named fileName: String) throws -> Data {
        let testBundle = Bundle(for: type(of: self))
        guard let url = testBundle.url(forResource: fileName, withExtension: "json") else {
            throw NSError(domain: "File not found", code: 1, userInfo: nil)
        }

        return try Data(contentsOf: url)
    }
}
