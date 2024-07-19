//
//  CategoryViewModel.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 04.07.2024.
//

import SwiftUI
import Combine

final class CategoryViewModel: ObservableObject {

    @Published var categories: [String: Category] = [:]

    var categoriesList: [Category] {
        Array(categories.values).sorted { $0.createdAt < $1.createdAt }
    }

    private let categoryCache: CategoryCache
    private var cancellables = Set<AnyCancellable>()

    init(categoryCache: CategoryCache = CategoryCache.shared) {
        self.categoryCache = categoryCache
        setupBindings()
    }

    func removeItem(id: String) {
        categoryCache.removeItemAndSaveJson(id: id)
    }

    private func setupBindings() {
        categoryCache.$items
            .sink { [weak self] newItems in
                self?.categories = newItems
            }
            .store(in: &cancellables)
    }

}
