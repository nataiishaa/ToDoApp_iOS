//
//  AddCategoryView.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 05.07.2024.
//

import Foundation
import SwiftUI
struct AddCategoryView: View {
    @Binding var customCategories: [CustomCategory]
    @Environment(\.dismiss) var dismiss
    @State private var categoryName: String = ""
    @State private var selectedColor: Color = .black

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Название категории")) {
                    TextField("Введите название", text: $categoryName)
                }
                Section(header: Text("Цвет категории")) {
                    ColorPicker("Выберите цвет", selection: $selectedColor)
                }
            }
            .navigationTitle("Новая категория")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        let newCategory = CustomCategory(name: categoryName, color: selectedColor)
                        customCategories.append(newCategory)
                        dismiss()
                    }
                }
            }
        }
    }
}
