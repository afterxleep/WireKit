//
//  TodoListAddView.swift
//  WireKitSample
//
//  Created by Daniel Bernal on 26/12/20.
//

import SwiftUI

struct TodoAddView: View {
        
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = TodoListViewModel()
    @State var todoText: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Text")
                        Spacer()
                        TextField("", text: $todoText)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .navigationBarTitle("Add Item")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }
}

extension TodoAddView {

    var cancelButton: some View {
        Button(
            action: {
                presentationMode.wrappedValue.dismiss()
            }) {
            Text("Cancel")
        }
    }

    var saveButton: some View {
        Button(
            action: {
                if(todoText.count > 0) {
                    viewModel.add(todo: Todo(userId: 1,
                                             id: nil,
                                             title: todoText,
                                             completed: false))
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        ) {
            Text("Save").disabled(todoText.count == 0)
        }
    }
}
