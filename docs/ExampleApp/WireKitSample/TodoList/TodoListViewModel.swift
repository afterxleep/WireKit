//
//  TodoListViewModel.swift
//  WireKitSample
//
//  Created by Daniel Bernal on 6/12/20.
//

import Foundation
import WireKit
import SwiftUI

class TodoListViewModel: ObservableObject {
    
    @Published var todoItems: [Todo] = []  // Todo Items (Result from API)
    @Published var isLoading: Bool = true // Show Hide the loader
    @Published var title = "Todo List"
    @Published var loadingMessage = "Loading Data..."
    
    let apiClient: WKAPIClient
    
    private enum Constants {
        static let apiURL = "https://jsonplaceholder.typicode.com"
        static let completedImage = "checkmark.circle"
        static let defaultImage = "circle"
    }
    
    init(apiClient: WKAPIClient) {
        self.apiClient = apiClient
        Task {
            await loadData()
        }
    }
    
    private func loadData() async {
        isLoading = true
        do {
            let todos: [Todo] = try await apiClient.dispatch(TodoAPI.FindAll())
            DispatchQueue.main.async {
                self.todoItems = todos
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                print("Error loading data: \(error)")
                self.isLoading = false
            }
        }
    }
    
    func todoImage(todoItem: Todo) -> (name: String, color: Color) {
        todoItem.completed ? (name: Constants.completedImage, color: .green) : (name: Constants.defaultImage, color: .red)
    }
    
    func delete(at offsets: IndexSet) {
        Task {
            for index in offsets {
                guard let id = todoItems[index].id else { continue }
                do {
                    let _: Empty = try await apiClient.dispatch(TodoAPI.Delete(id))
                    DispatchQueue.main.async {
                        self.todoItems.remove(at: index)
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Error deleting data: \(error)")
                    }
                }
            }
        }
    }
    
    func add(todo: Todo) {
        Task {
            do {
                let _: Todo = try await apiClient.dispatch(TodoAPI.Add(todo))
                DispatchQueue.main.async {
                    self.todoItems.append(todo)
                    print("Item Added Correctly")
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error adding data: \(error)")
                }
            }
        }
    }
}
