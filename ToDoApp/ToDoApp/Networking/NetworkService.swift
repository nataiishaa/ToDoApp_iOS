//
//  NetworkService.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 22.07.2024.
//

//struct Api {
//    func fetchData<T: Decodable>(_ url: URL) async throws -> T? {
//        let (data, _) = try await URLSession.shared.data(from: url)
//        return try decoder.decode(T.self, from: data)
//    }
//    
//    func fetchData<T: Decodable>(from urlString: String) async throws -> T? {
//        guard let url = URL(string: urlString) else {
//            return nil
//        }
//        return try await fetchData(url)
//    }
//}
import Foundation

struct Api {
    enum Constants {
        static let token = "Gildor"
    }

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    func fetchData<T: Decodable>(_ url: URL) async throws -> T? {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decoder.decode(T.self, from: data)
    }
    
    func fetchData<T: Decodable>(from urlString: String) async throws -> T? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        return try await fetchData(url)
    }
    
    func postData<T: Decodable, Body: Encodable>(_ url: URL, body: Body) async throws -> T? {
        return try await sendRequest(url, method: "POST", body: body)
    }
    
    func putData<T: Decodable, Body: Encodable>(_ url: URL, body: Body) async throws -> T? {
        return try await sendRequest(url, method: "PUT", body: body)
    }
    
    func patchData<T: Decodable, Body: Encodable>(_ url: URL, body: Body) async throws -> T? {
        return try await sendRequest(url, method: "PATCH", body: body)
    }
    
    func deleteData<T: Decodable>(_ url: URL) async throws -> T? {
        return try await sendRequest(url, method: "DELETE", body: Optional<Data>.none)
    }
    
    func postData<T: Decodable, Body: Encodable>(from urlString: String, body: Body) async throws -> T? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        return try await postData(url, body: body)
    }
    
    func putData<T: Decodable, Body: Encodable>(from urlString: String, body: Body) async throws -> T? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        return try await putData(url, body: body)
    }
    
    func patchData<T: Decodable, Body: Encodable>(from urlString: String, body: Body) async throws -> T? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        return try await patchData(url, body: body)
    }
    
    func deleteData<T: Decodable>(from urlString: String) async throws -> T? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        return try await deleteData(url)
    }
    
    private func sendRequest<T: Decodable, Body: Encodable>(_ url: URL, method: String, body: Body?) async throws -> T? {
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body = body {
            request.httpBody = try encoder.encode(body)
            request.setValue("Bearer \(Constants.token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode(T.self, from: data)
    }
}




