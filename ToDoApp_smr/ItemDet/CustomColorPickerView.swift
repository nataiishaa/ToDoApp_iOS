//
//  CustomColorPickerView.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 25.06.2024.
//

import Foundation
import SwiftUI

struct CustomColorPickerView: View {

    @Binding var colorValue: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(colorValue)
                .frame(width: 30, height: 30)
                .overlay(Circle().stroke(Color.white, lineWidth: 2))

            ColorPicker("", selection: $colorValue)
                .labelsHidden()
                .opacity(0.015)
        }
        .shadow(radius: 5.0)
    }
}
