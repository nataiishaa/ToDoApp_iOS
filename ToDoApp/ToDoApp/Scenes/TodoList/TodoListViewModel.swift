//
//  TodoListViewModel.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 27.06.2024.
//
import SwiftUI
import Combine

final class TodoListViewModel: ObservableObject {

    @Published var todoItems: [TodoItem] = []
    @Published var todoViewPresented: Bool = false {
        didSet {
            if !todoViewPresented {
                selectedTodoItem = nil
            }
        }
    }
    @Published var calendarViewPresented: Bool = false
    @Published var selectedTodoItem: TodoItem?
    @Published var newTodo: String = ""
    @Published var showCompleted: Bool = true {
        didSet {
            updateTodoItemsList()
        }
    }
    @Published var sortType: SortType = .addition {
        didSet {
            updateTodoItemsList()
        }
    }
    private var todoItemCache: TodoItemCache

    enum SortType {
        case priority, addition
        var descriptionOfNext: String {
            switch self {
            case .priority:
                return String(localized: "sort.byAddition")
            case .addition:
                return String(localized: "Сортировать по важности")
            }
        }
    }

    var todoItemToOpen: TodoItem {
        if let selectedTodoItem {
            return selectedTodoItem
        }
        return TodoItem.empty
    }

    var doneCount: Int {
        todoItemCache.items.values.filter({ $0.isDone }).count
    }

    private var cancellables = Set<AnyCancellable>()
    private var worker: NetworkingService

    init(todoItemCache: TodoItemCache = TodoItemCache.shared, worker: NetworkingService = ToDoWorker()) {
        self.todoItemCache = todoItemCache
        self.worker = worker
        setupBindings()
        Task {
            await loadToDoItems()
        }
    }

    func addItem(_ item: TodoItem) async {
        do {
            let response = try await worker.addTodoItem(item)
            await MainActor.run {
                print("Adding item to cache: \(response.item)")
                self.todoItemCache.addItemAndSaveJson(response.item)
            }
        } catch {
            print("Failed to add todo item: \(error)")
        }
    }

    func toggleDone(_ todoItem: TodoItem) async {
        let toggledItem = todoItem.toggleDone(!todoItem.isDone)
        do {
            let response = try await worker.updateTodoItem(toggledItem)
            await MainActor.run {
                print("Updating item in cache: \(response.item)")
                self.todoItemCache.addItemAndSaveJson(response.item)
            }
        } catch {
            print("Failed to update todo item: \(error)")
        }
    }

    func delete(_ todoItem: TodoItem) async {
        do {
            let response = try await worker.deleteTodoItem(withId: todoItem.id)
            await MainActor.run {
                print("Removing item from cache: \(response.item.id)")
                self.todoItemCache.removeItemAndSaveJson(id: response.item.id)
            }
        } catch {
            print("Failed to delete todo item: \(error)")
        }
    }

    func toggleShowCompleted() {
        showCompleted.toggle()
    }

    func toggleSortType() {
        sortType = sortType == .addition ? .priority : .addition
    }

    func colorFor(todoItem: TodoItem) -> Color? {
        guard let hex = todoItem.color else { return nil }
        return Color(hex: hex)
    }

    private func updateTodoItemsList() {
        todoItems = applyFilters(items: Array(todoItemCache.items.values))
        print("Updated todoItems: \(todoItems)")
    }

    private func setupBindings() {
        todoItemCache.$items
            .sink { [weak self] newItems in
                guard let self = self else { return }
                print("Updating todoItems with new cache data")
                self.todoItems = self.applyFilters(items: Array(newItems.values))
            }
            .store(in: &cancellables)
    }

    private func applyFilters(items: [TodoItem]) -> [TodoItem] {
        var result = switch sortType {
        case .priority:
            items.sorted {
                if $0.priority == $1.priority {
                    return $0.createdAt < $1.createdAt
                } else {
                    return $0.priority > $1.priority
                }
            }
        case .addition:
            items.sorted { $0.createdAt < $1.createdAt }
        }
        if !showCompleted {
            result = result.filter { !$0.isDone }
        }
        return result
    }

    private func loadToDoItems() async {
        do {
            let response = try await worker.fetchTodoList()
            await MainActor.run {
                print("Loading items from server: \(response.items)")
                self.todoItems = response.items
                self.todoItemCache.replaceItems(with: Dictionary(uniqueKeysWithValues: response.items.map { ($0.id, $0) }))
            }
        } catch {
            print("Failed to fetch todo items: \(error)")
        }
    }
}
