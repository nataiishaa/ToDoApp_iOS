//
//  TodoItem+CSV.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 19.06.2024.
//

import Foundation

extension TodoItem {
    static func parse(csv: String) -> [TodoItem] {
        var toDoItems = [TodoItem]()
        
        let rows = csv.split(separator: "\n")
                
        for row in rows {
            let csvRow = String(row)
            if let todoItem = TodoItem.fromCSV(csvRow) {
                toDoItems.append(todoItem)
            }
        }
        
        return toDoItems
    }
    
    func toCSV() -> String {
        let deadlineString = deadline?.description ?? ""
        let changeDateString = changeDate?.description ?? ""
        let colorString = color ?? "#FFFFFF"
        
        let escapedText = text.contains(",") ? "\"\(text)\"" : text 
        
        return "\(id),\(escapedText),\(importance.rawValue),\(deadlineString),\(isCompleted),\(createDate.description),\(changeDateString),\(colorString)"
    }
    
    static func fromCSV(_ csvString: String) -> TodoItem? {
        var components = [String]()
        var currentComponent = ""
        var insideText = false
        
        for char in csvString {
            if char == "\"" {
                insideText.toggle()
            } else if char == "," && !insideText {
                components.append(currentComponent)
                currentComponent = ""
            } else {
                currentComponent.append(char)
            }
        }
        
        components.append(currentComponent)
                
        guard components.count >= 7 else {
            return nil
        }
        
        guard let id = UUID(uuidString: components[0]) else { return nil }
        let text = components[1]
        let importance = Priority(rawValue: components[2]) ?? .usual
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss ZZZ"
        
        let deadline = components[3].isEmpty ? nil : dateFormatter.date(from: components[3])
        let isCompleted = components[4] == "true"
        guard let createDate = dateFormatter.date(from: components[5]) else { return nil }
        let changeDate = components.count > 6 ? dateFormatter.date(from: components[6]) : nil
        let color = components.count > 7 ? components[7] : "#FFFFFF"
        
        return TodoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, createDate: createDate, changeDate: changeDate, color: color)
    }
}


