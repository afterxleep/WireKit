//
//  TodoListViewModel.swift
//  WireKitSample
//
//  Created by Daniel Bernal on 6/12/20.
//

import Foundation
import WireKit
import Combine
import SwiftUI

class TodoListViewModel: ObservableObject {
    
    @Published var todoItems: [Todo] = []  // Todo Items (Result from API)
    @Published var isLoading: Bool = true // Show Hide the loader
    @Published var title = "Todo List"
    @Published var loadingMessage = "Loading Data..."
    
    private var apiClient: WKAPIClient
    private var cancellables = [AnyCancellable]()
    
    private enum Constants {
        static let apiURL = "https://jsonplaceholder.typicode.com"
        static let completedImage = "checkmark.circle"
        static let defaultImage = "circle"
    }
    
    init() {
        apiClient = WKAPIClient(baseURL: Constants.apiURL)
        loadData()
    }
    
    private func loadData() {
        
        // Perform a request from the TodoAPI
        // You can pass parameters and other data here.
        apiClient.dispatch(TodoAPI.FindAll())
            
            // Since we are displaying results in the UI, receive on Main Thread
            .receive(on: DispatchQueue.main)
            
            // Observe for Returned values
            .sink(
                receiveCompletion: { result in
                    
                    // Hide our loader on completion
                    self.isLoading = false
                    
                    // Act on when we get a result or failure
                    switch result {
                        case .failure(let error):
                            // Handle API response errors here (WKNetworkRequestError)
                            print("Error loading data: \(error)")
                        default: break
                    }
                },
                receiveValue: { value in
                
                    // Populate the observable property in the UI
                    self.todoItems = value
                })
            
            // Store the cancellable in a set (to hold a ref)
            .store(in: &cancellables)
    }
    
    // Quick helper method to set color and icon for each todo
    func todoImage(todoItem: Todo) -> (name: String, color: Color) {
        todoItem.completed ? (name: Constants.completedImage, color: .green) : (name: Constants.defaultImage, color: .red)
    }
    
    func delete(at offsets: IndexSet) {
        for o in offsets {
            guard let id = todoItems[o].id else { return }
            todoItems.remove(at: o)
            apiClient.dispatch(TodoAPI.Delete(id))
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { result in
                        switch result {
                            case .failure(let error):
                                print("Error deleting data: \(error)")
                            default:
                                print("Item Deleted Correctly")
                                // You could reload the list from the server here
                                // We're not doing it as this is a Mock API
                                //self.loadData()
                                break
                        }
                    },
                    receiveValue: { value in
                        print("Response: \(value)")
                        // The received value is empty
                    })
                .store(in: &cancellables)
        }
    }
    
    func add(todo: Todo) {
        apiClient.dispatch(TodoAPI.Add(todo))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { result in
                    switch result {
                        case .failure(let error):
                            print("Error adding data: \(error)")
                        default:
                            print("Item Added Correctly")
                            // You could reload the list from the server here
                            // We're not doing it as this is a Mock API
                            //self.loadData()
                            break
                    }
                },
                receiveValue: { value in
                    print("Response: \(value)")
                    // The received value is empty
                })
            .store(in: &cancellables)
        
    }
    
}
