import Foundation
import SwiftUI

public struct TodoItem: Identifiable, Equatable, Hashable {
	public static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
		lhs.id == rhs.id
	}
	
	public let id: UUID
	public let text: String
	public let importance: Priority
	public let category: ItemCategory
	public let deadline: Date?
	public let isCompleted: Bool
	public let createDate: Date
	public let changeDate: Date?
	public var color: String?
	public var files: [String]?
	
	public init(id: UUID = UUID(), text: String, importance: Priority, category: ItemCategory, deadline: Date? = nil, isCompleted: Bool, createDate: Date = Date(), changeDate: Date? = nil, color: String = "#FFFFFF", files: [String]? = nil) {
		self.id = id
		self.text = text
		self.importance = importance
		self.category = category
		self.deadline = deadline
		self.isCompleted = isCompleted
		self.createDate = createDate
		self.changeDate = changeDate
		self.color = color
		self.files = files
	}
}
public enum Priority: String, CaseIterable, Identifiable {
	case unimportant
	case usual
	case important
	
	public var id: Self { self }
}

enum Importance: String, Codable {
	case low = "неважная"
	case normal = "обычная"
	case high = "важная"
}

extension TodoItem {
	func updated(text: String? = nil, importance: Priority? = nil, category: ItemCategory? = nil, deadline: Date? = nil, isCompleted: Bool? = nil, changeDate: Date = Date(), color: String? = nil, files: [String]? = nil) -> TodoItem {
		return TodoItem(
			id: self.id,
			text: text ?? self.text,
			importance: importance ?? self.importance,
			category: category ?? self.category,
			deadline: deadline ?? self.deadline,
			isCompleted: isCompleted ?? self.isCompleted,
			createDate: self.createDate,
			changeDate: changeDate,
			color: color ?? self.color ?? "#FFFFFF",
			files: files ?? nil
		)
	}
}

extension TodoItem {
	public var json: Any {
		var data: [String: Any] = [
			"id": id.uuidString,
			"text": text,
			"isCompleted": isCompleted,
			"createDate": createDate.timeIntervalSince1970
		]
		
		if importance != .usual {
			data["importance"] = importance.rawValue
		}
		
		if case let .standard(standardCategory) = category, standardCategory != .other {
			data["category"] = standardCategory.rawValue
		} else if case let .custom(customCategory) = category {
			data["category"] = customCategory.id.uuidString
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
	
	public static func parse(json: Any) -> TodoItem? {
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
		
		let categoryRawValue = json["category"] as? String
		let category = ItemCategory(rawValue: categoryRawValue ?? "other") ?? .standard(.other)
		
		var deadline: Date?
		if let deadlineTimeInterval = json["deadline"] as? TimeInterval {
			deadline = Date(timeIntervalSince1970: deadlineTimeInterval)
		}
		
		var changeDate: Date?
		if let changeDateTimeInterval = json["changeDate"] as? TimeInterval {
			changeDate = Date(timeIntervalSince1970: changeDateTimeInterval)
		}
		
		let color = json["color"] as? String ?? "#FFFFFF"
		
		return TodoItem(id: id, text: text, importance: importance, category: category, deadline: deadline, isCompleted: isCompleted, createDate: createDate, changeDate: changeDate, color: color)
	}
}

extension TodoItem {
	public static func parse(csv: String) -> [TodoItem] {
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
	
	public func toCSV() -> String {
		let deadlineString = deadline?.description ?? ""
		let changeDateString = changeDate?.description ?? ""
		let colorString = color ?? "#FFFFFF"
		
		let escapedText = text.contains(",") ? "\"\(text)\"" : text // заключаем текстовое поле в кавычки, если оно содержит запятые
		
		return "\(id),\(escapedText),\(importance.rawValue),\(deadlineString),\(isCompleted),\(createDate.description),\(changeDateString),\(colorString)"
	}
	
	public static func fromCSV(_ csvString: String) -> TodoItem? {
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
		
		guard components.count >= 8 else {
			return nil
		}
		
		guard let id = UUID(uuidString: components[0]) else { return nil }
		let text = components[1]
		let importance = Priority(rawValue: components[2]) ?? .usual
		let category = ItemCategory(rawValue: components[3]) ?? .standard(.other)
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss ZZZ"
		
		let deadline = components[4].isEmpty ? nil : dateFormatter.date(from: components[3])
		let isCompleted = components[5] == "true"
		guard let createDate = dateFormatter.date(from: components[6]) else { return nil }
		let changeDate = components.count > 7 ? dateFormatter.date(from: components[7]) : nil
		let color = components.count > 8 ? components[8] : "#FFFFFF"
		
		return TodoItem(id: id, text: text, importance: importance, category: category, deadline: deadline, isCompleted: isCompleted, createDate: createDate, changeDate: changeDate, color: color)
	}
}
