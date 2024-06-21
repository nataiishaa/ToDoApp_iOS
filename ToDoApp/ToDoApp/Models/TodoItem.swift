import Foundation

struct TodoItem: Identifiable, Codable {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isCompleted: Bool
    let creationDate: Date
    var modificationDate: Date?

    enum Importance: String, Codable {
        case low = "неважная"
        case normal = "обычная"
        case high = "важная"
    }

    init(id: String? = nil, text: String, importance: Importance = .normal, deadline: Date? = nil, isCompleted: Bool = false, creationDate: Date = Date(), modificationDate: Date? = nil) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }
}

