//
//  CalendarView.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 01.07.2024.
//

import SwiftUI

struct CalendarView: UIViewControllerRepresentable {

    typealias UIViewControllerType = UINavigationController

    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: CalendarViewController())
    }

    func updateUIViewController(
        _ uiViewController: UINavigationController,
        context: Context
    ) {}

}

#Preview {
    CalendarView()
        .ignoresSafeArea()
}
