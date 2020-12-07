//
//  Todo.swift
//  WireKitSample
//
//  Created by Daniel Bernal on 6/12/20.
//

import Foundation
import WireKit

struct Todo: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
    





