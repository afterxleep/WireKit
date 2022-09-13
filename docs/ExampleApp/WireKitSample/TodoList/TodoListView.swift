//
//  TodoListView.swift
//  WireKitSample
//
//  Created by Daniel Bernal on 6/12/20.
//

import SwiftUI

struct TodoListView: View {
    
    @StateObject var viewModel = TodoListViewModel()
    @State var showingAddForm: Bool = false
    
    var body: some View {
        if viewModel.isLoading  {
            ProgressView(viewModel.loadingMessage)
        }
        else {
            NavigationView {
                List {
                    ForEach(viewModel.todoItems) { todoItem in
                        todoItemView(todoItem: todoItem)
                    }.onDelete(perform: delete)
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle(viewModel.title)
                .navigationBarItems(trailing: addButton)
            }
        }
    }
}

extension TodoListView {
    
    func delete(at offsets: IndexSet) {
        viewModel.delete(at: offsets)
    }
}

extension TodoListView {
    
    var addButton: some View {
        Group {
            Button(
                action: { showingAddForm = true }) {
                Image(systemName: "plus.circle").imageScale(.medium)
                }.sheet(isPresented: $showingAddForm) {
                    TodoAddView()
                }
            }
        }
    
    func todoItemView(todoItem: Todo) -> some View {
        
            let image = viewModel.todoImage(todoItem: todoItem)
            return HStack {
                Image(systemName: image.name)
                    .foregroundColor(image.color)
                Text(todoItem.title)
            }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TodoListViewModel()
        TodoListView(viewModel: viewModel,
                     showingAddForm: false)
    }
}

