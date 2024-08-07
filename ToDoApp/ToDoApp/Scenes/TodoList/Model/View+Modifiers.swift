//
//  View+Modifiers.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 27.06.2024.
//

import SwiftUI


extension View {

    func markableAsDone(isDone: Bool, onAction: @escaping () -> Void) -> some View {
        modifier(MarkAsDoneSwipe(isDone: isDone, onAction: onAction))
    }

    func groupedList() -> some View {
        modifier(GroupedList())
    }

    func deletable(onAction: @escaping () -> Void) -> some View {
        modifier(DeleteSwipe(onAction: onAction))
    }

    func withInfo(onAction: @escaping () -> Void) -> some View {
        modifier(InfoSwipe(onAction: onAction))
    }

}
