//
//  DefaultCircle.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 29.06.2024.
//

import Foundation
import SwiftUI

struct SolvedCircle: View {
    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(.green)

    }
}

#Preview {
    SolvedCircle()
}

struct DefaultCircle: View {
    var body: some View {
        Image(systemName: "circle")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(.colorGrayLight)
    }
}

#Preview {
    DefaultCircle()
}


struct DoneCircle: View {
    var body: some View {
        Image(systemName: "circle")
            .resizable()
            .foregroundColor(.red)
            .frame(width: 20, height: 20)
            .overlay(
                Image(systemName: "circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.colorLightRed)
                    .frame(width: 20, height: 20)
            )
    }
}

#Preview {
    DoneCircle()
}
