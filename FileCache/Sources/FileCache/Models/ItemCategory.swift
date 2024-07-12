//
//  ItemCategory.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 05.07.2024.
//

import Foundation
import SwiftUI

public enum DefaultCategory: String, CaseIterable, Identifiable, Hashable {
	case work
	case study
	case hobby
	case other
	
	public var id: Self { self }
}

public struct CustomCategory: Identifiable, Codable, Hashable {
	public var id = UUID()
	public var name: String
	public var colorHex: String
	
	public var color: Color {
		Color(hex: colorHex)
	}
	
	enum CodingKeys: CodingKey {
		case id, name, colorHex
	}
	
	public init(id: UUID = UUID(), name: String, color: Color) {
		self.id = id
		self.name = name
		self.colorHex = color.hexString
	}
}



public enum ItemCategory: Identifiable, Hashable {
	case standard(DefaultCategory)
	case custom(CustomCategory)
	
	public var id: UUID {
		switch self {
			case .standard(let category):
				return UUID(uuidString: category.rawValue) ?? UUID()
			case .custom(let customCategory):
				return customCategory.id
		}
	}
	
	public var name: String {
		switch self {
			case .standard(let category):
				switch category {
					case .work:
						return "Работа"
					case .study:
						return "Учеба"
					case .hobby:
						return "Хобби"
					case .other:
						return "Другое"
				}
			case .custom(let customCategory):
				return customCategory.name
		}
	}
	
	public var color: Color {
		switch self {
			case .standard(let category):
				switch category {
					case .work:
						return .red
					case .study:
						return .blue
					case .hobby:
						return .green
					case .other:
						return .gray
				}
			case .custom(let customCategory):
				return customCategory.color
		}
	}
	
	public init?(rawValue: String) {
		if let standardCategory = DefaultCategory(rawValue: rawValue) {
			self = .standard(standardCategory)
		} else {
			if let savedCategories = UserDefaults.standard.data(forKey: "customCategories"),
			   let customCategories = try? JSONDecoder().decode([CustomCategory].self, from: savedCategories),
			   let customCategory = customCategories.first(where: { $0.id.uuidString == rawValue }) {
				self = .custom(customCategory)
			} else {
				return nil
			}
		}
	}
}
