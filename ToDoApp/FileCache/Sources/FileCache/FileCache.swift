import Foundation
import SwiftUI

public protocol StringIdentifiable: Identifiable where ID == String {}

public protocol FileCachableJson {
    var json: Any { get }
    static func parse(json: Any) -> Self?
}

public protocol FileCachableCsv {
    var csv: String { get }
    static var csvHeader: [String] { get }
    static func parse(csv: String) -> Self?
}

public typealias FileCachable = StringIdentifiable & FileCachableJson & FileCachableCsv

open class FileCache<T: FileCachable>: ObservableObject {
    @Published public private(set) var items: [String: T] = [:]
    private let fileManager: FileManager = FileManager.default
    private let defaultFileName: String
    private var container: ModelContainer?

    public init(defaultFileName: String) {
        self.defaultFileName = defaultFileName
        self.container = try? ModelContainer(for: [TodoItem.self])
    }

    public func addItemAndSaveJson(_ item: T) {
        addItem(item)
        try? saveJson()
    }

    public func removeItemAndSaveJson(id: String) {
        removeItem(id: id)
        try? saveJson()
    }
    
    public func replaceItems(with newItems: [String: T]) {
        DispatchQueue.main.async {
            self.items = newItems
        }
    }

    public func addItem(_ item: T) {
        DispatchQueue.main.async {
            self.items[item.id] = item
        }
    }

    @discardableResult
    public func removeItem(id: String) -> T? {
        var removedItem: T?
        DispatchQueue.main.sync {
            removedItem = self.items.removeValue(forKey: id)
        }
        return removedItem
    }

    public func removeAllItems() {
        DispatchQueue.main.async {
            self.items = [:]
        }
    }

    private func filePath(_ file: String) -> URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(file)
    }

    // MARK: - JSON serialization
    public func saveJson(to file: String? = nil) throws {
        let fileName = file ?? defaultFileName
        let jsonArray = items.values.map { $0.json }
        let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
        try jsonData.write(to: filePath(fileName))
    }

    public func loadJson(from file: String? = nil) throws {
        let fileName = file ?? defaultFileName
        let data = try Data(contentsOf: filePath(fileName))
        let json = try JSONSerialization.jsonObject(with: data)
        guard let jsonArray = json as? [Any] else {
            throw FileCacheError.parseError
        }
        let itemsList = jsonArray.compactMap { T.parse(json: $0) }
        DispatchQueue.main.async {
            self.items = itemsList.reduce(into: [:]) { result, item in
                result[item.id] = item
            }
        }
    }

    // MARK: - CSV serialization
    public func saveCSV(to file: String) throws {
        let csvString = "\(T.csvHeader.joined(separator: ","))\n" + items.values.map { $0.csv }.joined(separator: "\n")
        guard let csvData = csvString.data(using: .utf8) else {
            throw FileCacheError.encodingError
        }
        try csvData.write(to: filePath(file))
    }

    public func loadCSV(from file: String) throws {
        let content = try String(contentsOf: filePath(file), encoding: .utf8)
        let rows = content.split(separator: "\n").map { String($0) }.dropFirst()
        let itemsList = rows.compactMap { T.parse(csv: $0) }
        DispatchQueue.main.async {
            self.items = itemsList.reduce(into: [:]) { result, item in
                result[item.id] = item
            }
        }
    }

    // MARK: - SwiftData Methods
    public func insert(_ todoItem: TodoItem) {
        container?.insert(todoItem)
    }
    
    public func fetch() -> [TodoItem] {
        return container?.fetch(TodoItem.self) ?? []
    }
    
    public func delete(_ todoItem: TodoItem) {
        container?.delete(todoItem)
    }
    
    public func update(_ todoItem: TodoItem) {
        container?.update(todoItem)
    }

    // MARK: - FileCacheError
    public enum FileCacheError: LocalizedError {
        case parseError, encodingError

        public var errorDescription: String? {
            switch self {
            case .parseError: return "Parsing failed"
            case .encodingError: return "String encoding error"
            }
        }
    }
}

// SwiftData ModelContainer
class ModelContainer {
    private var items: [String: TodoItem] = [:]
    
    init(for models: [TodoItem.Type]) throws {
    }
    
    func insert(_ item: TodoItem) {
        items[item.id] = item
    }
    
    func fetch(_ type: TodoItem.Type) -> [TodoItem] {
        return Array(items.values)
    }
    
    func delete(_ item: TodoItem) {
        items.removeValue(forKey: item.id)
    }
    
    func update(_ item: TodoItem) {
        items[item.id] = item
    }
}

