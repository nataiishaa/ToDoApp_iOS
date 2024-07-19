//
//  RetryHandler.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 19.07.2024.
//

import Foundation

final class RetryHandler {

    private let minDelay: Double = 2.0
    private let maxDelay: Double = 120.0
    private let factor: Double = 1.5
    private let jitter: Double = 0.05

    func retry<T>(action: @escaping () async throws -> T) async throws -> T {
        var delay = minDelay
        while true {
            do {
                return try await action()
            } catch {
                if delay >= maxDelay {
                    throw error
                }
                let jitteredDelay = delay + (delay * jitter * (Double.random(in: -1...1)))
                try await Task.sleep(nanoseconds: UInt64(jitteredDelay * Double(NSEC_PER_SEC)))
                delay *= factor
            }
        }
    }
}
