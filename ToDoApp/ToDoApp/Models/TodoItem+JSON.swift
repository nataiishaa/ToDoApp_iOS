//
//  TodoItem+JSON.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 19.06.2024.
//

import Foundation

import Foundation

extension TodoItem {
    var json: Any {
        var data: [String: Any] = [
            "id": id.uuidString,
            "text": text,
            "isCompleted": isCompleted,
            "createDate": createDate.timeIntervalSince1970
        ]
        
        if importance != .usual {
            data["importance"] = importance.rawValue
        }
        
        if let deadline = deadline {
            data["deadline"] = deadline.timeIntervalSince1970
        }
        
        if let changeDate = changeDate {
            data["changeDate"] = changeDate.timeIntervalSince1970
        }
        
        if let color = color {
            data["color"] = color
        }
        
        return data
    }
    
    static func parse(json: Any) -> TodoItem? {
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let id = (json["id"] as? String).flatMap({ UUID(uuidString: $0) }),
              let text = json["text"] as? String,
              let isCompleted = json["isCompleted"] as? Bool,
              let createDateInterval = json["createDate"] as? TimeInterval else {
            return nil
        }
        
        let createDate = Date(timeIntervalSince1970: createDateInterval)
        
        let importanceRawValue = json["importance"] as? String
        let importance = Priority(rawValue: importanceRawValue ?? "usual") ?? .usual
        
        var deadline: Date? = nil
        if let deadlineTimeInterval = json["deadline"] as? TimeInterval {
            deadline = Date(timeIntervalSince1970: deadlineTimeInterval)
        }
        
        var changeDate: Date? = nil
        if let changeDateTimeInterval = json["changeDate"] as? TimeInterval {
            changeDate = Date(timeIntervalSince1970: changeDateTimeInterval)
        }
        
        let color = json["color"] as? String ?? "#FFFFFF"
        
        return TodoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, createDate: createDate, changeDate: changeDate, color: color)
    }
}
