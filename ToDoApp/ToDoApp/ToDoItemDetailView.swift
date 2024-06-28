//
//  ToDoItemDetailView.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 29.06.2024.
//

import Foundation
import SwiftUI

struct ToDoItemDetailView: View {
    @State var itemID: UUID
    @ObservedObject var viewModel: ViewModel
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var fileCache: FileCache
    
    init(itemID: UUID) {
        self._itemID = State(initialValue: itemID)
        self._viewModel = ObservedObject(initialValue: ViewModel(id: itemID))
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.currentOrientation == .landscapeLeft || viewModel.currentOrientation == .landscapeRight {
                landscape
                    .background(Color(.systemBackground))
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
                                DispatchQueue.main.async {
                                    viewModel.save()
                                }
                                dismiss()
                            }.disabled(viewModel.text.isEmpty)
                        }
                    }
                    .onAppear {
                        DispatchQueue.global().async {
                            self.viewModel.setup(self.fileCache)
                        }
                        if let colorHex = viewModel.item?.color {
                            viewModel.selectedColor = Color(hex: colorHex)
                        }
                    }
            } else {
                portrait
                    .background(Color(.systemBackground))
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
                                DispatchQueue.main.async {
                                    viewModel.save()
                                    dismiss()
                                }
                            }.disabled(viewModel.text.isEmpty)
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            self.viewModel.setup(self.fileCache)
                            if let colorHex = viewModel.item?.color {
                                viewModel.selectedColor = Color(hex: colorHex)
                            }
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
                .listRowBackground(Color(.systemGroupedBackground))
                
                Section {
                    importancePicker
                    deadlineToggle
                    if viewModel.isDeadline {
                        calendarPicker
                    }
                }
                .listRowBackground(Color(.systemGroupedBackground))
                
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
                            .foregroundColor(.primary)
                            
                            Spacer()
                            
                            CustomColorPickerView(colorValue: $viewModel.selectedColor)
                        }
                    }
                }
                .listRowBackground(Color(.systemGroupedBackground))
                
                Section {
                    deleteButton
                }
                .listRowBackground(Color(.systemGroupedBackground))
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
                        .background(Color(.systemGroupedBackground))
                        .transition(.slide)
                }
                .listRowBackground(Color(.systemGroupedBackground))
            }
            .scrollContentBackground(.hidden)
            
            if !isFocused {
                Form {
                    Section {
                        importancePicker
                        deadlineToggle
                        if viewModel.isDeadline {
                            calendarPicker
                        }
                    }
                    .listRowBackground(Color(.systemGroupedBackground))
                    
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
                                .foregroundColor(.primary)
                                
                                Spacer()
                                
                                CustomColorPickerView(colorValue: $viewModel.selectedColor)
                            }
                        }
                    }
                    .listRowBackground(Color(.systemGroupedBackground))
                    
                    Section {
                        deleteButton
                    }
                    .listRowBackground(Color(.systemGroupedBackground))
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
                .foregroundColor(isFocused || !viewModel.text.isEmpty ? .primary : .secondary)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Готово") {
                            isFocused = false
                        }
                    }
                }
       
        }
    }
    
    var importancePicker: some View {
        HStack {
            Text("Важность")
                .foregroundColor(.primary)
                .font(.system(size: 17))
            Spacer()
            Picker("Важность", selection: $viewModel.importance) {
                ForEach(Priority.allCases) { priority in
                    switch priority {
                    case .unimportant:
                        Image(systemName: "arrow.down")
                            .foregroundColor(.gray)
                    case .usual:
                        Text("нет")
                    case .important:
                        Image(systemName: "exclamationmark.2")
                            .foregroundColor(.red)
                    }
                }
            }
            .frame(width: 175)
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    var deadlineToggle: some View {
        Toggle(isOn: $viewModel.isDeadline.animation()) {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Сделать до")
                        .foregroundColor(.primary)
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
        .datePickerStyle(GraphicalDatePickerStyle())
        .environment(\.locale, Locale(identifier: "ru"))
    }
    
    var deleteButton: some View {
        Button(role: .destructive){
            DispatchQueue.global().async {
                viewModel.delete()
            }
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

