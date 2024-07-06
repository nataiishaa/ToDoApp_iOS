//
//  CompleteCircle.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 29.06.2024.
//

import Foundation
import SwiftUI

struct CompleteCircle: View {
    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(.green)

    }
}

#Preview {
    CompleteCircle()
}
