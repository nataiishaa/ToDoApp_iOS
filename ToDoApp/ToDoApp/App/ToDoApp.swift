//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 15.06.2024.
//

import SwiftUI



//@main
//struct ToDoAppApp: App {
//
//    init() {
//        Logger.setup()
//    }
//
//    var body: some Scene {
//       WindowGroup {
//          TodoList()
//       }
//
//    }
//
//}
@main
struct ToDoAppApp: App {

    init() {
        Logger.setup()
    }

    var body: some Scene {
        WindowGroup {
            TodoList()
            let networkingService = DefaultNetworkingService(token: "Gildor")
            //let initialTodoItem = TodoItem(
//                text: "Initial Todo Item",
//                priority: .medium,
//                deadline: nil,
//                isDone: false,
//                createdAt: Date(),
//                modifiedAt: nil,
//                color: nil,
//                categoryId: nil
//            )
            //TodoView(viewModel: TodoViewModel(todoItem: initialTodoItem, networkingService: networkingService))
        }
    }
}
