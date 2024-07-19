//
//  CategoryCache.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 03.07.2024.
//

import Foundation
import FileCache

final class CategoryCache: FileCache<Category> {

    static let shared = CategoryCache()

    private let defaultCategories: [Category] = [
        Category(
            text: String(localized: "Работа"),
            color: "#ff3b30",
            createdAt: Date(timeIntervalSince1970: 1)
        ),
        Category(
            text: String(localized: "Учеба"),
            color: "#007aff",
            createdAt: Date(timeIntervalSince1970: 2)
        ),
        Category(
            text: String(localized: "Хобби"),
            color: "#34c759",
            createdAt: Date(timeIntervalSince1970: 3)
        ),
        Category(
            text: String(localized: "Выбрать"),
            color: nil,
            createdAt: Date(timeIntervalSince1970: 4)
        )
    ]

    private override init(defaultFileName: String = "categories.json") {
        super.init(defaultFileName: defaultFileName)
        addDefaultCategories()
    }

    private func addDefaultCategories() {
        try? loadJson()
        if items.isEmpty {
            defaultCategories.forEach { category in
                addItem(category)
            }
            try? saveJson()
        }
    }
}
