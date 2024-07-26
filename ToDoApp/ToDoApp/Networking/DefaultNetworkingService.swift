//
//  DefaultNetworkingService.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 19.07.2024.
//

import Foundation

final class DefaultNetworkingService: ObservableObject, NetworkingService {
    //static let shared: NetworkingService = DefaultNetworkingService(token: "Gildor")
    static let shared = DefaultNetworkingService(token: "Gildor")
    private let baseUrl = URL(string: "https://hive.mrdekk.ru/todo")!
    private let session: URLSession
    private let token: String
    @Published var isLoading = false
    init(session: URLSession = .shared, token: String) {
        self.session = session
        self.token = token
    }

    private func createRequest(endpoint: String, method: String, body: Data? = nil, revision: Int? = nil) -> URLRequest {
        var url = baseUrl.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if let revision = revision {
            request.setValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        }
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }

    func fetchTodoList() async throws -> TodoListResponse {
        let request = createRequest(endpoint: "list", method: "GET")
        let (data, response) = try await session.data(for: request)
        guard !data.isEmpty else {
            throw NSError(domain: "DataError", code: 100, userInfo: [NSLocalizedDescriptionKey: "Получен пустой ответ от сервера"])
        }
        return try JSONDecoder().decode(TodoListResponse.self, from: data)
    }
    func updateTodoList(with list: [TodoItem], revision: Int) async throws -> TodoListResponse {
        let body = try JSONEncoder().encode(list)
        let request = createRequest(endpoint: "list", method: "PATCH", body: body, revision: revision)
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(TodoListResponse.self, from: data)
    }

    func fetchTodoItem(withId id: String) async throws -> TodoItemResponse {
        let request = createRequest(endpoint: "list/\(id)", method: "GET")
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(TodoItemResponse.self, from: data)
    }

    func addTodoItem(_ item: TodoItem) async throws -> TodoItemResponse {
        let body = try JSONEncoder().encode(item)
        let request = createRequest(endpoint: "list", method: "POST", body: body)
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(TodoItemResponse.self, from: data)
    }

    func updateTodoItem(_ item: TodoItem) async throws -> TodoItemResponse {
        let body = try JSONEncoder().encode(item)
        let request = createRequest(endpoint: "list/\(item.id)", method: "PUT", body: body)
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(TodoItemResponse.self, from: data)
    }

    func deleteTodoItem(withId id: String) async throws -> TodoItemResponse {
        let request = createRequest(endpoint: "list/\(id)", method: "DELETE")
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(TodoItemResponse.self, from: data)
    }
}
