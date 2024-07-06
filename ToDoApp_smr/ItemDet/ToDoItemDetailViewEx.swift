//
//  ToDoItemDetailView.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 29.06.2024.
//


import Foundation
import SwiftUI

extension ToDoItemDetailView {
    class ViewModel: ObservableObject {
        
        var id: UUID
        var fileCache = FileCache.shared
        var item: TodoItem?
        var dateConverter = DateConverter()
        @Published var text = ""
        @Published var emptyText = "Что надо сделать?"
        @Published var importance = Priority.usual
        @Published var category = ItemCategory.standard(.other)
        @Published var isDeadline = false
        @Published var dateDeadline = Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now
        @Published var showColorPicker = false
        @Published var selectedColor: Color = .white
        @Published var allCategories: [ItemCategory] = []
        
        @Published var customCategories: [CustomCategory] = [] {
            didSet {
                saveCustomCategories()
            }
        }
       
          

        init(id: UUID = UUID()) {
            self.id = id
            loadCategories()
        }
        
        var dateDeadlineFormated: String {
            dateConverter.convertDateToStringDayMonthYear(date: dateDeadline)
        }
        
        func setup() {
            self.item = fileCache.toDoItems[id]
            guard let newItem = item else { return }
            self.text = newItem.text
            self.importance = newItem.importance
            self.category = newItem.category
            guard let newDeadline = newItem.deadline else { return }
            self.dateDeadline = newDeadline
            self.isDeadline = true
        }
        
        func save() {
            let todoItem = TodoItem(
                id: self.id,
                text: self.text,
                importance: self.importance,
                category: self.category,
                deadline: self.isDeadline ? self.dateDeadline : nil,
                isCompleted: false,
                color: self.selectedColor.hexString
            )
            fileCache.updateTodoItem(todoItem, to:"Save.json")
        }
        
        func delete() {
            guard let item = self.item else { return }
            self.fileCache.deleteTodoItem(item.id)
            self.fileCache.saveTodoItems(to: "Save.json")
        }
        
        func loadCategories() {
            let customCategories = loadCustomCategories()
            let standardCategories = DefaultCategory.allCases.map { ItemCategory.standard($0) }
            allCategories = standardCategories + customCategories.map { ItemCategory.custom($0) }
        }
        
        private func loadCustomCategories() -> [CustomCategory] {
            if let savedCategories = UserDefaults.standard.data(forKey: "customCategories"),
               let decodedCategories = try? JSONDecoder().decode([CustomCategory].self, from: savedCategories) {
                return decodedCategories
            }
            return []
        }
        
        private func saveCustomCategories() {
            if let encoded = try? JSONEncoder().encode(customCategories) {
                UserDefaults.standard.set(encoded, forKey: "customCategories")
            }
        }
        
        @Published var currentOrientation = UIDevice.current.orientation
        
        let orientationHasChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .makeConnectable()
            .autoconnect()
    }
}
