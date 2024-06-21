//
//  TodoItem+CSV.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 19.06.2024.
//

import Foundation
extension TodoItem {
    static func fromCSV(csvString: String) -> TodoItem? {
        var components = csvString.components(separatedBy: ",")
        components = components.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        guard components.count >= 6,
              let id = components[0] as String?,
              let text = components[1] as String?,
              let isCompleted = Bool(components[3]),
              let creationDate = ISO8601DateFormatter().date(from: components[4]) else {
            return nil
        }

        let importance = Importance(rawValue: components[2]) ?? .normal
        let modificationDate = ISO8601DateFormatter().date(from: components[5])
        let deadline = components.count > 6 ? ISO8601DateFormatter().date(from: components[6]) : nil

        return TodoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, creationDate: creationDate, modificationDate: modificationDate)
    }

    var csv: String {
        let dateFormatter = ISO8601DateFormatter()

        func escapeCsv(_ value: String) -> String {
            if value.contains(",") || value.contains("\"") {
                return "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
            }
            return value
        }

        var components = [
            escapeCsv(id),
            escapeCsv(text),
            escapeCsv(importance.rawValue),
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
