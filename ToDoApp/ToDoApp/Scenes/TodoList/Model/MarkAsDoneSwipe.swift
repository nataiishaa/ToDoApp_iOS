//
//  MarkAsDoneSwipe.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 27.06.2024.
//

import SwiftUI

struct MarkAsDoneSwipe: ViewModifier {

    var isDone: Bool
    var onAction: () -> Void

    func body(content: Content) -> some View {
        content
            .swipeActions(edge: .leading) {
                Button(role: .cancel) {
                    onAction()
                } label: {
                    if isDone {
                        undoneLabel
                    } else {
                        doneLabel
                    }
                }
            }
    }

    private var doneLabel: some View {
        label(text: "Выполнено", tint: .primaryGreen, systemImage: "checkmark.circle.fill")
    }

    private var undoneLabel: some View {
        label(text: "Не выполнено", tint: .primaryRed, systemImage: "x.circle.fill")
    }

    private func label(text: LocalizedStringKey, tint: Color, systemImage: String) -> some View {
        Label(text, systemImage: systemImage).tint(tint)
    }

}
