//
//  ViewExtensions.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 25.06.2024.
//

import SwiftUI

extension View {

    public func addBorder<S>(
        _ content: S,
        width: CGFloat = 1,
        cornerRadius: CGFloat
    ) -> some View where S: ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect).overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }

}

extension UIView {

    func addSubviewWithoutAutoresizingMask(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }

    func alignSubview(_ view: UIView, with margin: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin.left),
            view.topAnchor.constraint(equalTo: topAnchor, constant: margin.top),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin.right),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin.bottom)
        ])
    }

    func setFont(_ font: UIFont) {
        if let adjustable = self as? UIContentSizeCategoryAdjusting {
            adjustable.adjustsFontForContentSizeCategory = true
        }

        switch self {
        case let self as UILabel: self.font = font
        case let self as UITextField: self.font = font
        case let self as UITextView: self.font = font
        default: fatalError("\(self.debugDescription) is not supported")
        }
    }

}
