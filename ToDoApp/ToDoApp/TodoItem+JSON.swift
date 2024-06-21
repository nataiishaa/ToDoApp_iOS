//
//  TodoItem+JSON.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 19.06.2024.
//

import Foundation

extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []),
              let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
              let id = dictionary["id"] as? String,
              let text = dictionary["text"] as? String,
              let isCompleted = dictionary["isCompleted"] as? Bool,
              let creationDateString = dictionary["creationDate"] as? String,
              let creationDate = ISO8601DateFormatter().date(from: creationDateString) else {
            return nil
        }

        let dateFormatter = ISO8601DateFormatter()
        let modificationDateString = dictionary["modificationDate"] as? String
        let modificationDate = modificationDateString != nil ? dateFormatter.date(from: modificationDateString!) : nil
        let importance = Importance(rawValue: (dictionary["importance"] as? String) ?? "обычная") ?? .normal
        let deadlineString = dictionary["deadline"] as? String
        let deadline = deadlineString != nil ? dateFormatter.date(from: deadlineString!) : nil

        return TodoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, creationDate: creationDate, modificationDate: modificationDate)
    }

    var json: Any {
        let dateFormatter = ISO8601DateFormatter()
        var dict: [String: Any] = [
            "id": id,
            "text": text,
            "isCompleted": isCompleted,
            "creationDate": dateFormatter.string(from: creationDate)
        ]

        if let modificationDate = modificationDate {
            dict["modificationDate"] = dateFormatter.string(from: modificationDate)
        }
        if importance != .normal {
            dict["importance"] = importance.rawValue
        }
        if let deadline = deadline {
            dict["deadline"] = dateFormatter.string(from: deadline)
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []),
              let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
            return [:]
        }

        return jsonResult
    }
}
