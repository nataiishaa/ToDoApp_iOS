//
//  DeleteSwipe.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 28.06.2024.
//

import SwiftUI

struct DeleteSwipe: ViewModifier {

    var onAction: () -> Void

    func body(content: Content) -> some View {
        content.swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                onAction()
            } label: {
                Label("delete", systemImage: "trash")
            }
            .tint(.primaryRed)
        }
    }

}
