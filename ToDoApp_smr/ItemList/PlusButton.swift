//
//  PlusButton.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 29.06.2024.
//

import Foundation
import SwiftUI

struct PlusButton: View {
    var body: some View {
        VStack {
            Spacer()
            Circle()
                .frame(width: 50, height: 50)
                .foregroundStyle(.colorBlue)
                .overlay {
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                        .bold()
                }
                .shadow(color: .colorBlue, radius: 10)
        }
    }
}

#Preview {
    PlusButton()
}
