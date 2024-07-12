// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

public final class FileCache: ObservableObject {
	
	public static let shared = FileCache()
	
	private init() {}
	
	@Published public var toDoItems: [UUID: TodoItem] = [:]
	
	public func addTodoItem(_ newTask: TodoItem) {
		self.toDoItems[newTask.id] = newTask
	}
	
	public func deleteTodoItem(_ id: UUID) {
		self.toDoItems.removeValue(forKey: id)
	}
	
	public func saveTodoItems(to fileName: String) {
		let url = self.getDocumentsDirectory().appendingPathComponent(fileName)
		let jsonArray = self.toDoItems.values.map { $0.json }
		
		do {
			let data = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
			try data.write(to: url)
		} catch {
			print("Failed to save: \(error.localizedDescription)")
		}
	}
	
	public func updateTodoItem(_ todo: TodoItem, to fileName: String) {
		DispatchQueue.main.async {
			self.toDoItems[todo.id] = todo
			self.saveTodoItems(to: fileName)
		}
	}
	
	public func updateTodoItem(id: UUID, text: String? = nil, importance: Priority? = nil, category: ItemCategory? = nil, deadline: Date? = nil, isCompleted: Bool? = nil, color: String? = nil, to fileName: String) {
		guard let existingItem = toDoItems[id] else { return }
		
		let updatedItem = existingItem.updated(
			text: text,
			importance: importance,
			category: category,
			deadline: deadline,
			isCompleted: isCompleted
		)
		
		DispatchQueue.main.async {
			self.toDoItems[id] = updatedItem
			self.saveTodoItems(to: fileName)
		}
	}
	
	public func loadTodoItems(from fileName: String) {
		let url = self.getDocumentsDirectory().appendingPathComponent(fileName)
		do {
			let data = try Data(contentsOf: url)
			let decodedData = try JSONSerialization.jsonObject(with: data, options: [])
			guard let jsonArray = decodedData as? [[String: Any]] else { return }
			
			var newItems: [UUID: TodoItem] = [:]
			for item in jsonArray {
				if let item = TodoItem.parse(json: item) {
					newItems[item.id] = item
				}
			}
			
			DispatchQueue.main.async {
				self.toDoItems = newItems
			}
		} catch {
			print("Failed to load: \(error.localizedDescription)")
		}
	}
	
	public func getTodoItems() -> [TodoItem] {
		return Array(toDoItems.values)
	}
	
	private func getDocumentsDirectory() -> URL {
		return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
	}
}
