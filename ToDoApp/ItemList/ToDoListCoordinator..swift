//
//  TodoItemListViewModel.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 25.06.2024.
//

import Foundation
import SwiftUI
import Combine

extension TodoItemList {
    class ViewModel: ObservableObject {
        
        @Published var filteredItems: [TodoItem] = []
        @Published var selectedItem: TodoItem?
        @Published var showDetailView = false
        @Published var currentSortOption: SortOption = .byDate
        
        var fileCache = FileCache.shared
        var completedCount = 0
        private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        private var cancellables: Set<AnyCancellable> = []
        var showCompleted = true
        var firstInit = true
        
        
        func setup() {
            self.setupSubscriptions()
        }
        
        private func setupSubscriptions() {
            fileCache.$toDoItems
                .sink { [weak self] items in
                    self?.filteredItems = Array(items.values)
                    self?.updateFilteredItems(items: items, sortOption: self?.currentSortOption ?? .byDate)
                    self?.completedCount = items.values.filter { $0.isCompleted }.count
                }
                .store(in: &cancellables)
        }
        
        func deleteItem(id: UUID) {
            fileCache.deleteTodoItem(id)
            fileCache.saveTodoItems(to: "Save.json")
        }
        
        func compliteItem(item: TodoItem) {
            fileCache.updateTodoItem(
                id: item.id,
                isCompleted: !item.isCompleted,
                to: "Save.json"
            )
        }
        
        func loadItems() {
            self.fileCache.loadTodoItems(from: "Save.json")
            if self.firstInit {
                self.firstInit.toggle()
                self.sortedByCreatingDate()
                self.hideCompletedTasks()
            }
        }
        
        func getItem(by id: UUID) -> TodoItem? {
            return fileCache.toDoItems[id]
        }
        
        func triggerFeedback() {
            feedbackGenerator.impactOccurred()
        }
        
        private func updateFilteredItems(items: [UUID: TodoItem], sortOption: SortOption) {
            if showCompleted {
                self.filteredItems = items.values.sorted {
                    if $0.isCompleted == $1.isCompleted {
                        switch sortOption {
                        case .byDate:
                            return $0.createDate > $1.createDate
                        case .byImportance:
                            return compareImportance($0.importance, $1.importance)
                        case .none:
                            return false
                        }
                    }
                    return $0.isCompleted && !$1.isCompleted
                }
            } else {
                self.filteredItems = items.values.filter { !$0.isCompleted }.sorted {
                    switch sortOption {
                    case .byDate:
                        return $0.createDate > $1.createDate
                    case .byImportance:
                        return compareImportance($0.importance, $1.importance)
                    case .none:
                        return false
                    }
                }
            }
        }
        
        func sortedByCreatingDate() {
            self.currentSortOption = .byDate
            self.filteredItems.sort {
                if $0.isCompleted == $1.isCompleted {
                    return $0.createDate > $1.createDate
                }
                return $0.isCompleted && !$1.isCompleted
            }
        }
        
        func sortedByImportance() {
            self.currentSortOption = .byImportance
            self.filteredItems.sort {
                if $0.isCompleted == $1.isCompleted {
                    return compareImportance($0.importance, $1.importance)
                }
                return !$0.isCompleted && $1.isCompleted
            }
        }
        
        private func compareImportance(_ a: Priority, _ b: Priority) -> Bool {
            let order: [Priority: Int] = [.important: 0, .usual: 1, .unimportant: 2]
            return order[a]! < order[b]!
        }
        
        func showCompletedTasks() {
            self.showCompleted = true
            self.filteredItems = fileCache.toDoItems.values.sorted {
                if $0.isCompleted == $1.isCompleted {
                    return $0.createDate > $1.createDate
                }
                return $0.isCompleted && !$1.isCompleted
            }
            
        }
        
        func hideCompletedTasks() {
            self.showCompleted = false
            self.filteredItems = fileCache.toDoItems.values.filter { !$0.isCompleted }.sorted(by: { $0.createDate > $1.createDate })
            
        }
        
        enum SortOption: String {
            case none = "Без сортировки"
            case byDate = "По дате создания"
            case byImportance = "По важности"
        }
    }
}
