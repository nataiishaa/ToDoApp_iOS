//
//  TodoItem+CSV.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 19.06.2024.
//
import Foundation

extension TodoItem {
    static func fromCSV(csvString: String) -> TodoItem? {
        let components = csvString.components(separatedBy: ",")
        guard components.count >= 6,
              let id = components[0].trimmingCharacters(in: .whitespacesAndNewlines) as String?,
              let text = components[1].trimmingCharacters(in: .whitespacesAndNewlines) as String?,
              let isCompleted = Bool(components[3].trimmingCharacters(in: .whitespacesAndNewlines)),
              let creationDate = ISO8601DateFormatter().date(from: components[4].trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return nil
        }

        let importance = Importance(rawValue: components[2].trimmingCharacters(in: .whitespacesAndNewlines)) ?? .normal
        let modificationDate = ISO8601DateFormatter().date(from: components[5].trimmingCharacters(in: .whitespacesAndNewlines))
        let deadline = components.count > 6 ? ISO8601DateFormatter().date(from: components[6].trimmingCharacters(in: .whitespacesAndNewlines)) : nil

        return TodoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, creationDate: creationDate, modificationDate: modificationDate)
    }

    var csv: String {
        let dateFormatter = ISO8601DateFormatter()
        var components = [
            id,
            text,
            importance.rawValue,
            "\(isCompleted)",
            dateFormatter.string(from: creationDate)
        ]

        if let modificationDate = modificationDate {
            components.append(dateFormatter.string(from: modificationDate))
        } else {
            components.append("")
        }

        if let deadline = deadline {
            components.append(dateFormatter.string(from: deadline))
        } else {
            components.append("")
        }

        return components.joined(separator: ",")
    }
}
