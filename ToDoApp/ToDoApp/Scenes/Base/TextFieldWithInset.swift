//
//  TextFieldWithInset.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 03.07.2024.
//

import UIKit

final class CustomPaddedTextField: UITextField {

    private struct Inset {
        static let defaultPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).inset(by: Inset.defaultPadding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return super.placeholderRect(forBounds: bounds).inset(by: Inset.defaultPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds).inset(by: Inset.defaultPadding)
    }

}
