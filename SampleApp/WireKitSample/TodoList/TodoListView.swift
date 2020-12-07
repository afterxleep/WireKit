//
//  TodoListView.swift
//  WireKitSample
//
//  Created by Daniel Bernal on 6/12/20.
//

import SwiftUI

struct TodoListView: View {
    
    @StateObject var viewModel = TodoListViewModel()
    
    var body: some View {
        if viewModel.isLoading  {
            ProgressView(viewModel.loadingMessage)
        }
        else {
            NavigationView {
                List(viewModel.todoItems) { todoItem in
                    let image = viewModel.todoImage(todoItem: todoItem)
                    Image(systemName: image.name)
                        .foregroundColor(image.color)
                    Text(todoItem.title)
                }.navigationBarTitle(viewModel.title)
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
