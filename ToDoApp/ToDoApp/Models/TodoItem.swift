import Foundation
import SwiftUI

struct TodoItem: Identifiable, Equatable {
    let id: UUID
    let text: String
    let importance: Priority
    let deadline: Date?
    let isCompleted: Bool
    let createDate: Date
    let changeDate: Date?
    var color: String?
    
    init(id: UUID = UUID(), text: String, importance: Priority, deadline: Date? = nil, isCompleted: Bool, createDate: Date = Date(), changeDate: Date? = nil, color: String = "#FFFFFF") {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.createDate = createDate
        self.changeDate = changeDate
        self.color = color
    }

}

enum Priority: String, CaseIterable, Identifiable {
    case unimportant
    case usual
    case important
    
    var id: Self { self }
}

enum Importance: String, Codable {
    case low = "неважная"
    case normal = "обычная"
    case high = "важная"
}

extension TodoItem {
    func updated(text: String? = nil, importance: Priority? = nil, deadline: Date? = nil, isCompleted: Bool? = nil, changeDate: Date = Date(), color: String? = nil) -> TodoItem {
        return TodoItem(
            id: self.id,
            text: text ?? self.text,
            importance: importance ?? self.importance,
            deadline: deadline ?? self.deadline,
            isCompleted: isCompleted ?? self.isCompleted,
            createDate: self.createDate,
            changeDate: changeDate,
            color: color ?? self.color ?? "#FFFFFF"
        )
    }
}



