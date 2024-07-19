//
//  UIViewControllerExtensions.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 29.06.2024.
//

import UIKit

extension UIViewController {

    func hideKeyboardWhenTappedAround(cancelsTouchesInView: Bool = true) {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard)
        )
        tap.cancelsTouchesInView = cancelsTouchesInView
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
