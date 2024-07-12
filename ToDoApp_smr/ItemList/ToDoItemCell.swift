//
//  ToDoItemCell.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 29.06.2024.
//

import SwiftUI
import FileCache

struct ToDoItemCell: View {

    let fileCache = FileCache.shared
    @State var todoId: UUID
    var dateConverter = DateConverter()
    var action: () -> Void

    var body: some View {
        HStack {
            smallCircle
            VStack(alignment: .leading) {
                textTask
                calendar
            }
            .padding(.leading, 5)
            Spacer()
            colorRectangle
            Image(systemName: "chevron.right")
                .foregroundStyle(.colorGray)

        }
        .onTapGesture {
            action()
        }
    }

    var colorRectangle: some View {
        Rectangle()
            .fill(Color(hex: fileCache.toDoItems[todoId]?.color ?? "#FFFFFF"))
            .frame(width: 5)
            .overlay(Rectangle().stroke(Color.labelPrimary, style: StrokeStyle(lineWidth: 1)))
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
                        DoneCircle()
                    } else {
                        if todo.importance == .important {
                            SolvedCircle()
                        } else {
                            DefaultCircle()
                        }
                    }
                }
                .onTapGesture {
                    fileCache.updateTodoItem(id: todo.id, isCompleted: !todo.isCompleted, to: "S")
                }
            }
        }
    }
}

#Preview {
    ToDoItemCell(todoId: UUID()) {
        print("Item tapped")
    }
}
