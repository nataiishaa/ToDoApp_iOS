//
//  GroupedList.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 27.06.2024.
//

import SwiftUI

struct GroupedList: ViewModifier {

    func body(content: Content) -> some View {
        content
            .background(.backgroundPrimary)
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
    }

}
