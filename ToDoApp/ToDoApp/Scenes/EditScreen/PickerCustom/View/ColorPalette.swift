//
//  ColorPalette.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 28.06.2024.
//

import SwiftUI

struct ColorPalette: View {

    @Binding var selectedColor: Color
    @Binding var brightness: Double

    @State private var currentPoint: CGPoint = .zero
    private let colorPointSize = CGSize(width: 20, height: 20)

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let rect = CGRect(origin: .zero, size: size)

            Canvas { context, size in
                for x in stride(from: 0, to: size.width, by: colorPointSize.width) {
                    for y in stride(from: 0, to: size.height, by: colorPointSize.height) {
                        let color = getColor(at: CGPoint(x: x, y: y), in: size)
                        context.fill(
                            Path(
                                CGRect(
                                    x: x, y: y,
                                    width: colorPointSize.width,
                                    height: colorPointSize.height
                                )
                            ),
                            with: .color(color)
                        )
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let point = value.location
                        if rect.contains(point) {
                            currentPoint = point
                            updateColor(at: point, in: size)
                        }
                    }
            )
            .onChange(of: brightness) {
                updateColor(at: currentPoint, in: size)
            }
            .background(Color.clear)
            .overlay(
                Circle()
                    .stroke(.black, lineWidth: 1)
                    .fill(selectedColor)
                    .frame(width: 20, height: 20)
                    .position(currentPoint)
            )
        }

    }

    private func getColor(at point: CGPoint, in size: CGSize) -> Color {
        let hue = Double(point.x / size.width)
        let saturation = Double(point.y / size.height)
        return Color(
            hue: hue,
            saturation: saturation,
            brightness: brightness
        )
    }

    private func updateColor(at point: CGPoint, in size: CGSize) {
        selectedColor = getColor(at: point, in: size)
    }

}
extension Color {

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    var hex: String? {
        guard let components = cgColor?.components, components.count >= 3 else {
            return nil
        }

        let r = components[0]
        let g = components[1]
        let b = components[2]

        return String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        ).lowercased()
    }

}

extension UIColor {

    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }

}
