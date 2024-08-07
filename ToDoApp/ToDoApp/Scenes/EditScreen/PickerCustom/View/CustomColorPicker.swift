//
//  CustomColorPicker.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 28.06.2024.
//

import SwiftUI

struct CustomColorPicker: View {

    @Binding var selectedColor: Color
    @State var brightness: Double = 1.0

    var body: some View {
        VStack {
            ColorPalette(
                selectedColor: $selectedColor,
                brightness: $brightness
            )
            ColorPickerSlider(
                title: "",
                value: $brightness
            )
        }
        .background(.backgroundPrimary)
        .frame(maxHeight: 300)
        .ignoresSafeArea()
    }

}

#Preview {
    @State var selectedColor: Color = .white
    return CustomColorPicker(selectedColor: $selectedColor)
}
