//
//  FloatingButton.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 02.07.2024.
//

import UIKit

final class FloatingButton: UIButton {

    init(size: CGSize) {
        super.init(frame: CGRect(origin: .zero, size: size))
        setupButton(size: size)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton(size: CGSize) {
        let config = UIImage.SymbolConfiguration(pointSize: size.width, weight: .regular, scale: .default)
        setImage(UIImage(systemName: "plus.circle.fill")?.withConfiguration(config), for: .normal)
        layer.cornerRadius = size.width / 2
        setupShadow()
    }

    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor // Пример использования черного цвета для тени
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowOpacity = 0.5 // Сделаем тень менее интенсивной
    }
}
