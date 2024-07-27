//
//  Worker.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 22.07.2024.
//

import Foundation

import Foundation

final class ToDoWorker: NetworkingService {
    private let api = Api()
    
    private enum Const {
        static let baseUrl: String = "https://hive.mrdekk.ru/todo"
    }
    
    func fetchTodoList() async throws -> TodoListResponse {
        let urlString = "\(Const.baseUrl)/todos"
        guard let response: TodoListResponse = try await api.fetchData(from: urlString) else {
            throw NSError(domain: "FetchError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch todo list"])
        }
        return response
    }
    
    func updateTodoList(with list: [TodoItem], revision: Int) async throws -> TodoListResponse {
        let urlString = "\(Const.baseUrl)/todos?revision=\(revision)"
        guard let response: TodoListResponse = try await api.putData(from: urlString, body: list) else {
            throw NSError(domain: "UpdateError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to update todo list"])
        }
        return response
    }
    
    func fetchTodoItem(withId id: String) async throws -> TodoItemResponse {
        let urlString = "\(Const.baseUrl)/todos/\(id)"
        guard let response: TodoItemResponse = try await api.fetchData(from: urlString) else {
            throw NSError(domain: "FetchError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch todo item"])
        }
        return response
    }
    
    func addTodoItem(_ item: TodoItem) async throws -> TodoItemResponse {
        let urlString = "\(Const.baseUrl)/todos"
        guard let response: TodoItemResponse = try await api.postData(from: urlString, body: item) else {
            throw NSError(domain: "AddError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to add todo item"])
        }
        return response
    }

    func updateTodoItem(_ item: TodoItem) async throws -> TodoItemResponse {
        let urlString = "\(Const.baseUrl)/todos/\(item.id)"
        guard let response: TodoItemResponse = try await api.putData(from: urlString, body: item) else {
            throw NSError(domain: "UpdateError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to update todo item"])
        }
        return response
    }
    
    func deleteTodoItem(withId id: String) async throws -> TodoItemResponse {
        let urlString = "\(Const.baseUrl)/todos/\(id)"
        guard let response: TodoItemResponse = try await api.deleteData(from: urlString) else {
            throw NSError(domain: "DeleteError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to delete todo item"])
        }
        return response
    }
}

// Структура для представления задачи
struct ToDo: Codable {
    let id: Int
    let title: String
    let completed: Bool
}


