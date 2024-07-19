//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 15.06.2024.
//

import SwiftUI

@main
struct ToDoAppApp: App {

    init() {
        Logger.setup()
    }

    var body: some Scene {
        WindowGroup {
            TodoList()
        }
    }

}
