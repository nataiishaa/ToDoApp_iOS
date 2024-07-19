//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 15.06.2024.
//

import SwiftUI

@main
struct ToDoAppApp: App {
    let networkingService = DefaultNetworkingService.shared

    init() {
        Logger.setup()
    }

    var body: some Scene {
       WindowGroup {
          TodoList()
             .environmentObject(networkingService)
       }
    }
}
