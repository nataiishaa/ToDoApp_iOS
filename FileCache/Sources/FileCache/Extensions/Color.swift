//
//  Color.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 25.06.2024.
//

import Foundation
import SwiftUI

extension Color {
	init(hex: String) {
		let scanner = Scanner(string: hex)
		_ = scanner.scanString("#")
		
		var hexNumber: UInt64 = 0
		if scanner.scanHexInt64(&hexNumber) {
			if hex.count == 9 {
				self.init(
					red: Double((hexNumber >> 24) & 0xFF) / 255.0,
					green: Double((hexNumber >> 16) & 0xFF) / 255.0,
					blue: Double((hexNumber >> 8) & 0xFF) / 255.0,
					opacity: Double(hexNumber & 0xFF) / 255.0
				)
			} else {
				self.init(
					red: Double((hexNumber >> 16) & 0xFF) / 255.0,
					green: Double((hexNumber >> 8) & 0xFF) / 255.0,
					blue: Double(hexNumber & 0xFF) / 255.0,
					opacity: 1.0
				)
			}
		} else {
			self.init(red: 0, green: 0, blue: 0, opacity: 1.0)
		}
	}
	
	var hexString: String {
		guard let components = self.cgColor?.components else {
			return "#000000FF"
		}
		
		let red = components[0]
		let green = components[1]
		let blue = components[2]
		let alpha = components.count >= 4 ? components[3] : 1.0
		
		return String(
			format: "#%02X%02X%02X%02X",
			Int(red * 255),
			Int(green * 255),
			Int(blue * 255),
			Int(alpha * 255)
		)
	}
}
