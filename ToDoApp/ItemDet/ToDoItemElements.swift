//
//  ToDoItemDetailView.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 29.06.2024.
//

import SwiftUI
import SwiftUI

struct ToDoItemDetailView: View {
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var fileCache: FileCache
    @State var itemID: UUID
    @ObservedObject var viewModel: ViewModel
    
    
    init(itemID: UUID) {
        self._itemID = State(initialValue: itemID)
        self._viewModel = ObservedObject(initialValue: ViewModel(id: itemID))
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.currentOrientation == .landscapeLeft || viewModel.currentOrientation == .landscapeRight {
                landscape
                    .background(.backPrimary)
                    .navigationTitle("Дело")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Отменить") {
                                dismiss()
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Сохранить") {
                                viewModel.save()
                                dismiss()
                            }.disabled(viewModel.text.isEmpty)
                        }
                    }
                    .onAppear {
                        self.viewModel.setup()
                        if let colorHex = viewModel.item?.color {
                            viewModel.selectedColor = Color(hex: colorHex)
                        }
                    }
            }
            else {
                portrait
                    .background(.backPrimary)
                    .navigationTitle("Дело")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Отменить") {
                                dismiss()
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Сохранить") {
                                viewModel.save()
                                dismiss()
                            }.disabled(viewModel.text.isEmpty)
                        }
                    }
                    .onAppear {
                        self.viewModel.setup()
                        if let colorHex = viewModel.item?.color {
                            viewModel.selectedColor = Color(hex: colorHex)
                        }
                    }
            }
        }
        .onReceive(viewModel.orientationHasChanged) { _ in
            viewModel.currentOrientation = UIDevice.current.orientation
        }
    }
    
    var portrait: some View {
        VStack {
            Form {
                Section {
                    customTextEditor
                }
                .listRowBackground(Color.backSecondary)
                
                Section {
                    importancePicker
                    categoriesPicker
                    deadlineToggle
                    if viewModel.isDeadline {
                        calendarPicker
                    }
                }
                .listRowBackground(Color.backSecondary)
                
                Section {
                    Button(action: {
                        viewModel.showColorPicker.toggle()
                    }) {
                        HStack {
                            VStack(alignment: .leading){
                                Text("Цвет")
                                Text(viewModel.selectedColor.hexString)
                                    .bold()
                            }
                            .foregroundStyle(.labelPrimary)
                            
                            Spacer()
                            
                            CustomColorPickerView(colorValue: $viewModel.selectedColor)
                        }
                    }
                }
                .listRowBackground(Color.backSecondary)
                
                Section {
                    deleteButton
                }
                .listRowBackground(Color.backSecondary)
            }
            .scrollContentBackground(.hidden)
            .transition(.slide)
        }
    }
    
    var landscape: some View {
        HStack {
            Form {
                Section {
                    customTextEditor
                        .frame(maxWidth: isFocused ? .infinity : .none, maxHeight: .infinity)
                        .background(Color.backSecondary)
                        .transition(.slide)
                }
                .listRowBackground(Color.backSecondary)
            }
            .scrollContentBackground(.hidden)
            
            if !isFocused {
                Form {
                    Section {
                        importancePicker
                        categoriesPicker
                        deadlineToggle
                        if viewModel.isDeadline {
                            calendarPicker
                        }
                    }
                    .listRowBackground(Color.backSecondary)
                    
                    Section {
                        Button(action: {
                            viewModel.showColorPicker.toggle()
                        }) {
                            HStack {
                                VStack(alignment: .leading){
                                    Text("Цвет")
                                    Text(viewModel.selectedColor.hexString)
                                        .bold()
                                }
                                .foregroundStyle(.labelPrimary)
                                
                                Spacer()
                                
                                CustomColorPickerView(colorValue: $viewModel.selectedColor)
                            }
                        }
                    }
                    .listRowBackground(Color.backSecondary)
                    
                    Section {
                        deleteButton
                    }
                    .listRowBackground(Color.backSecondary)
                }
                .frame(maxWidth: .infinity)
                .scrollContentBackground(.hidden)
            }
        }
    }
    
    var customTextEditor: some View {
        ZStack {
            TextEditor(text: $viewModel.text)
                .frame(minHeight: 150, maxHeight: .infinity)
                .focused($isFocused)
                .foregroundStyle(isFocused || !viewModel.text.isEmpty ? .labelPrimary : .labelTertiary)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Готово") {
                            isFocused = false
                        }
                    }
                }
            if viewModel.text.isEmpty {
                VStack {
                    HStack {
                        Text(viewModel.emptyText)
                            .foregroundStyle(.tertiary)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
    
    var importancePicker: some View {
        HStack {
            Text("Важность")
                .foregroundStyle(.labelPrimary)
                .font(.system(size: 17))
            Spacer()
            Picker("Важность", selection: $viewModel.importance) {
                ForEach(Priority.allCases) { priority in
                    switch priority {
                    case .unimportant:
                        Image(systemName: "arrow.down")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.colorGray)
                    case .usual:
                        Text("нет")
                    case .important:
                        Image(systemName: "exclamationmark.2")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.colorRed)
                    }
                }
            }
            .frame(width: 175)
            .pickerStyle(.segmented)
        }
    }
    
    var categoriesPicker: some View {
        Picker("Категория", selection: $viewModel.category) {
            ForEach(viewModel.allCategories) { category in
                HStack {
                    Image(systemName: "circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundColor(category.color)
                    Text(category.name)
                }
                .tag(category)
            }
        }
        .pickerStyle(.menu)
    }
    
    var deadlineToggle: some View {
        Toggle(isOn: $viewModel.isDeadline.animation()) {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Сделать до")
                        .foregroundStyle(.labelPrimary)
                }
                
                if viewModel.isDeadline {
                    Text(viewModel.dateDeadlineFormated)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    var calendarPicker: some View {
        DatePicker(
            "Start Date",
            selection: $viewModel.dateDeadline,
            in: Date.now...,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .environment(\.locale, Locale.init(identifier: "ru"))
        
    }
    
    var deleteButton: some View {
        Button(role: .destructive){
            viewModel.delete()
            dismiss()
        } label: {
            HStack {
                Spacer()
                Text("Удалить")
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .disabled(viewModel.item?.id == nil)
    }
}

#Preview {
    ToDoItemDetailView(itemID: UUID())
}
