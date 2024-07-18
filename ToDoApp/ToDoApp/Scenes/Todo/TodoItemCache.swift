//
//  TodoItemCache.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 03.07.2024.
//

import FileCache

final class TodoItemCache: FileCache<TodoItem> {

    static let shared = TodoItemCache()

    private override init(defaultFileName: String = "items.json") {
        super.init(defaultFileName: defaultFileName)
    }

}
