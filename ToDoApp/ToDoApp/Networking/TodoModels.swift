//
//  TodoModels.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 19.07.2024.
//

import Foundation

//struct TodoListResponse: Codable {
//    let status: String
//    let list: [TodoItem]
//    let revision: Int
//}
//
//struct TodoItemResponse: Codable {
//    let status: String
//    let element: TodoItem
//    let revision: Int
//}

struct TodoListResponse: Decodable {
    let items: [TodoItem]
}

struct TodoItemResponse: Decodable {
    let item: TodoItem
}
