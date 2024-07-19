import SwiftUI
import Combine

final class TodoViewModel: ObservableObject {
    @Published var isNetworkActivityIndicatorVisible = false
    @Published var text: String
    @Published var priority: TodoItem.Priority {
        didSet {
            AnalyticsService.todoViewPriority(priority.rawValue)
        }
    }
    @Published var category: Category? {
        didSet {
            color = getColorFromCategory()
        }
    }
    @Published var deadline: Date?
    @Published var modifiedAt: Date?
    @Published var color: Color?

    @Published var isAlertShown = false
    @Published var isColorPickerShown = false
    @Published var isCategoryViewShown = false

    @Published var selectedDeadline: Date = .nextDay {
        didSet {
            deadline = isDeadlineEnabled ? selectedDeadline.stripTime() : nil
            AnalyticsService.todoViewDeadline(enabled: isDeadlineEnabled, date: deadline)
        }
    }
    @Published var isDeadlineEnabled: Bool {
        didSet {
            selectedDeadline = isDeadlineEnabled ? (todoItem.deadline ?? .nextDay) : .nextDay
            deadline = isDeadlineEnabled ? selectedDeadline.stripTime() : nil
            AnalyticsService.todoViewDeadline(enabled: isDeadlineEnabled, date: deadline)
        }
    }

    var canItemBeSaved: Bool {
        text != "" &&
        (
            text != todoItem.text ||
            priority != todoItem.priority ||
            deadline != todoItem.deadline ||
            category?.id != todoItem.categoryId
        )
    }

    var isItemNew: Bool {
        todoItemCache.items[todoItem.id] == nil
    }

    let todoItem: TodoItem
    private let todoItemCache: TodoItemCache
    private let categoryCache: CategoryCache
    private let networkingService: NetworkingService
    private let retryHandler = RetryHandler()

    private var cancellables = Set<AnyCancellable>()

    init(
        todoItem: TodoItem,
        todoItemCache: TodoItemCache = TodoItemCache.shared,
        categoryCache: CategoryCache = CategoryCache.shared,
        networkingService: NetworkingService
    ) {
        self.todoItem = todoItem
        self.todoItemCache = todoItemCache
        self.categoryCache = categoryCache
        self.networkingService = networkingService
        self.text = todoItem.text
        self.priority = todoItem.priority
        self.deadline = todoItem.deadline
        self.modifiedAt = todoItem.modifiedAt
        self.isDeadlineEnabled = todoItem.deadline != nil
        self.selectedDeadline = todoItem.deadline ?? .nextDay
        if let categoryId = todoItem.categoryId {
            category = categoryCache.items[categoryId]
            if let hex = category?.color {
                self.color = Color(hex: hex)
            }
        }
    }

    func fetchTodos() {
        isNetworkActivityIndicatorVisible = true
        Task {
            do {
                let response = try await retryHandler.retry { [self] in
                    try await networkingService.fetchTodoList()
                }
                DispatchQueue.main.async {
                    let itemsDict: [String: TodoItem] = Dictionary(uniqueKeysWithValues: response.list.map { ($0.id, $0) })
                    self.todoItemCache.replaceItems(with: itemsDict)  // Используем новый метод для замены элементов
                    self.isNetworkActivityIndicatorVisible = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isNetworkActivityIndicatorVisible = false
                }
                // Обработка ошибки
            }
        }
    }


    func saveItem() {
        isNetworkActivityIndicatorVisible = true
        print("Начало сохранения элемента")
        Task {
            do {
                let updatedItem = todoItem.copyWith(
                    text: text,
                    priority: priority,
                    deadline: deadline,
                    modifiedAt: modifiedAt,
                    color: category?.color,
                    categoryId: category?.id
                )
                
                print("Сохранение элемента: \(updatedItem)")
                if isItemNew {
                    let response: TodoItemResponse = try await retryHandler.retry {
                        try await self.networkingService.addTodoItem(updatedItem)
                    }
                    DispatchQueue.main.async {
                        print("Новый элемент сохранен: \(response.element)")
                        self.todoItemCache.addItemAndSaveJson(response.element)
                        self.isNetworkActivityIndicatorVisible = false
                    }
                } else {
                    let response: TodoItemResponse = try await retryHandler.retry {
                        try await self.networkingService.updateTodoItem(updatedItem)
                    }
                    DispatchQueue.main.async {
                        print("Элемент обновлен: \(response.element)")
                        self.todoItemCache.addItemAndSaveJson(response.element)
                        self.isNetworkActivityIndicatorVisible = false
                    }
                }
            } catch {
                print("Ошибка при сохранении элемента: \(error)")
                DispatchQueue.main.async {
                    self.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }

    func removeItem() {
        isNetworkActivityIndicatorVisible = true
        Task {
            do {
                try await retryHandler.retry { [self] in
                    let response: TodoItemResponse = try await networkingService.deleteTodoItem(withId: todoItem.id)
                    DispatchQueue.main.async {
                        self.todoItemCache.removeItemAndSaveJson(id: response.element.id)
                        self.isNetworkActivityIndicatorVisible = false
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isNetworkActivityIndicatorVisible = false
                }
                // Обработайте ошибку
            }
        }
    }

    private func getColorFromCategory() -> Color? {
        guard let hex = category?.color else { return nil }
        return Color(hex: hex)
    }
}
