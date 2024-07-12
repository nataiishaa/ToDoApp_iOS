//
//  NetworkManager.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 11.07.2024.
//

import Foundation
import CocoaLumberjackSwift

enum NetworkError: Error {
	case badResponse
}

extension URLSession {
	func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
		return try await withCheckedThrowingContinuation { continuation in
			let task = self.dataTask(with: urlRequest) { data, response, error in
				if let error = error {
					continuation.resume(throwing: error)
				} else if let data = data, let response = response {
					continuation.resume(returning: (data, response))
				} else {
					continuation.resume(throwing: NetworkError.badResponse)
				}
			}
			task.resume()
		}
	}
}
