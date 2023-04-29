//
//  WireKitSampleApp.swift
//  WireKitSample
//
//  Created by Daniel Bernal on 6/12/20.
//

import SwiftUI
import WireKit

@main
struct WireKitSampleApp: App {

    let model: TodoListViewModel

    private enum Constants {
        static let apiURL = "https://jsonplaceholder.typicode.com"
    }

    init() {
        let apiClient = WKAPIClient(baseURL: Constants.apiURL)
        self.model = TodoListViewModel(apiClient: apiClient)
    }

    var body: some Scene {
        WindowGroup {
            TodoListView(viewModel: self.model)
        }
    }
}
