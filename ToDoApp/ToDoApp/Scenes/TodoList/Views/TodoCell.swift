//
//  TodoCell.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 27.06.2024.
//

import SwiftUI

// MARK: - TodoCell
struct TodoCell: View {

    let todoItem: TodoItem
    let color: Color?
    let onTap: () -> Void
    let onRadioButtonTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                radioButton
                    .padding(.trailing, 12)
                    .onTapGesture {
                        onRadioButtonTap()
                    }
                VStack(alignment: .leading) {
                    HStack {
                        if let priorityImage {
                            priorityImage
                        }
                        text
                    }
                    if let deadline = todoItem.deadline {
                        deadlineView(deadline)
                    }
                }
                Spacer()
                Image(.strlv)
                    .padding(.trailing, 6)
                Rectangle()
                    .fill(color ?? .clear)
                    .frame(width: 6)
                    .padding(.vertical, -6)
            }
        }
        .listRowInsets(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 0))
        .listRowSeparatorTint(.primarySeparator)
        .alignmentGuide(.listRowSeparatorLeading) { _ in
            46
        }
    }

}

// MARK: - UI Elements
extension TodoCell {

    private var text: some View {
        Text(todoItem.text)
            .font(.todoBody)
            .foregroundStyle(todoItem.isDone ? .textTertiary : .textPrimary)
            .lineLimit(3)
            .truncationMode(.tail)
            .strikethrough(todoItem.isDone)
    }

    private var radioButton: Image {
        if todoItem.isDone {
            return Image(.radioButtonOn)
        }
        if todoItem.priority == .high {
            return Image(.radioButtonHigh)
        }
        return Image(.radioButtonOff)
    }

    private var priorityImage: Image? {
        switch todoItem.priority {
        case .low:
            Image(.priorityLow)
        case .medium:
            nil
        case .high:
            Image(.priorityHigh)
        }
    }

    private func deadlineView(_ deadline: Date) -> some View {
        HStack {
            Image(.calendar)
                .foregroundStyle(.textTertiary)
            Text(deadline.formatted(
                    .dateTime
                    .day(.twoDigits)
                    .month(.wide)))
                .font(.todoSubhead)
                .foregroundStyle(.textTertiary)
        }
    }

}

// MARK: - Preview
#Preview {
    TodoCell(
        todoItem: TodoItem(
            text: "Text",
            priority: .high,
            deadline: .now,
            isDone: false,
            createdAt: .now
        ),
        color: .primaryRed,
        onTap: {},
        onRadioButtonTap: {}
    )
}
