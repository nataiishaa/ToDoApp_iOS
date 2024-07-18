//
//  CustomSwipeActionBuilder.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 05.07.2024.
//

import UIKit

@MainActor
final class CustomSwipeActionBuilder {

    private var contextualActions: [UIContextualAction] = []

    @discardableResult
    func addSwipeAction(
        title: String,
        style: UIContextualAction.Style,
        color: UIColor?,
        icon: UIImage?,
        completion: @escaping (UIContextualAction, UIView, @escaping (Bool) -> Void) -> Void
    ) -> CustomSwipeActionBuilder {
        let swipeAction = UIContextualAction(style: style, title: title, handler: completion)
        swipeAction.backgroundColor = color
        swipeAction.image = icon
        contextualActions.append(swipeAction)
        return self
    }

    func generateConfiguration() -> UISwipeActionsConfiguration {
        return UISwipeActionsConfiguration(actions: contextualActions)
    }

}
