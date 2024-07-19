//
//  NetworkingService.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 19.07.2024.
//

import Foundation

protocol NetworkingService {
    func fetchTodoList() async throws -> TodoListResponse
    func updateTodoList(with list: [TodoItem], revision: Int) async throws -> TodoListResponse
    func fetchTodoItem(withId id: String) async throws -> TodoItemResponse
    func addTodoItem(_ item: TodoItem) async throws -> TodoItemResponse
    func updateTodoItem(_ item: TodoItem) async throws -> TodoItemResponse
    func deleteTodoItem(withId id: String) async throws -> TodoItemResponse
    //static var shared : NetworkingService { get }
}
