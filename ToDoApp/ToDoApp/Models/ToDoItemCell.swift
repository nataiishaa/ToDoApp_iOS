//
//  ToDoItemCell.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 29.06.2024.
//

import SwiftUI

struct ToDoItemCell: View {
    
    @EnvironmentObject var fileCache: FileCache
    @State var todoId: UUID
    var dateConverter = DateConverter()
    var action: () -> ()
    
    var body: some View {
        HStack {
            smallCircle
            VStack(alignment: .leading) {
                textTask
                calendar
            }
            .padding(.leading, 5)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.colorGray)
            
        }
        .padding(10)
        .background(
            Color(hex: fileCache.toDoItems[todoId]?.color ?? "#FFFFFF") // Цвет фона
        )
        .cornerRadius(10)
        .onTapGesture {
            action()
        }
    }
    
    var textTask: some View {
        HStack {
            if let todo = fileCache.toDoItems[todoId] {
                if !todo.isCompleted && todo.importance != .usual {
                    Text(todo.importance == .important ? Image(systemName: "exclamationmark.2") : Image(systemName: "arrow.down"))
                        .foregroundStyle(todo.importance == .important ? .colorRed : .colorGray)
                        .opacity(todo.isCompleted ? 0 : 1)
                        .animation(.easeInOut(duration: 2), value: todo.isCompleted)
                }
                
                Text("\(todo.text)")
                    .lineLimit(3)
                    .strikethrough(todo.isCompleted, color: .labelTertiary)
                    .foregroundStyle(todo.isCompleted ? .labelTertiary : .labelPrimary)
                    .animation(.default, value: todo.isCompleted)
                
            }
        }
        .transition(.opacity)
        .font(.system(size: 17))
    }
    
    var calendar: some View {
        HStack {
            if let todo = fileCache.toDoItems[todoId] {
                if let deadline = dateConverter.convertDateToStringDayMonth(date: todo.deadline) {
                    Text(Image(systemName: "calendar"))
                    
                    Text(deadline)
                }
            }
        }
        .font(.system(size: 15))
        .foregroundStyle(.labelTertiary)
    }
    
    var smallCircle: some View {
        VStack {
            if let todo = fileCache.toDoItems[todoId] {
                VStack {
                    if todo.isCompleted {
                        SolvedCircle()
                    } else {
                        if todo.importance == .important {
                            DoneCircle()
                        } else {
                            DefaultCircle()
                        }
                    }
                }
                .onTapGesture {
                    DispatchQueue.main.async {
                        fileCache.updateTodoItem(id: todo.id, isCompleted: !todo.isCompleted, to: "Save.json")
                        
                    }
                }
            }
        }
    }
}

