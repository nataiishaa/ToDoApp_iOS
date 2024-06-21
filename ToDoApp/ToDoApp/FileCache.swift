//
//  FileCache.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 18.06.2024.
//

import Foundation

class FileCache {
    private(set) var tasks: [TodoItem] = []

    func addTask(_ task: TodoItem) {
        if !tasks.contains(where: { $0.id == task.id }) {
            tasks.append(task)
        }
    }

    func removeTask(by id: String) {
        tasks.removeAll { $0.id == id }
    }

    func saveToFile() {
        guard let data = try? JSONEncoder().encode(tasks) else { return }
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("tasks.json")
        try? data.write(to: url)
    }

    func loadFromFile() {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("tasks.json")
        guard let data = try? Data(contentsOf: url),
              let loadedTasks = try? JSONDecoder().decode([TodoItem].self, from: data) else { return }
        tasks = loadedTasks
    }
}
