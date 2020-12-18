//
//  Encodable+Dictionary.swift
//  WireKit
//
//  Created by Daniel Bernal on 8/11/20.
//

import Foundation

public extension Encodable {
  
    var asDictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
    
}
