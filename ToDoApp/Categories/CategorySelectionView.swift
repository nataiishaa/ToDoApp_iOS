//
//  CategorySelectionView.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 05.07.2024.
//

import Foundation
import SwiftUI

struct CategorySelectionView: View {
    @StateObject var viewModel = AddCategoryView.ViewModel()
    @State private var showAddCategoryView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.allCategories) { category in
                    Text(category.name)
                        .foregroundColor(category.color)
                }
                
                Button(action: {
                    showAddCategoryView = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Добавить новую категорию")
                    }
                }
                .sheet(isPresented: $showAddCategoryView) {
                    AddCategoryView(viewModel: viewModel)
                }
            }
            .navigationTitle("Категории")
        }
    }
}

#Preview {
    CategorySelectionView()
}
