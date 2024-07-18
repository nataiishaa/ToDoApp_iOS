//
//  PlainButton.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 28.06.2024.
//

import UIKit

final class PlainButton: ButtonDefault {

    init(
        title: String = "",
        foregroundColor: UIColor = .textPrimary,
        font: UIFont = .todoBody
    ) {
        super.init(
            icon: nil,
            title: title,
            backgroundColor: .clear,
            foregroundColor: foregroundColor,
            font: font
        )
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10,
                                                               bottom: 10, trailing: 10)
        configuration?.background.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
