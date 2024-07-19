//
//  NewCategoryUIView.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 03.07.2024.
//

import UIKit

@MainActor
protocol NewCategoryUIViewDelegate: AnyObject {
    func didChangeTextField(text: String)
}

final class NewCategoryUIView: UIView, BaseScrollableView {

    weak var delegate: NewCategoryUIViewDelegate?
    let scrollView = UIScrollView()
    private enum Constants {
        static let inset: CGFloat = 20
        enum ColorPicker {
            static let height: CGFloat = 250
        }
    }

    private let contentView = UIView()
    private let textField: CustomPaddedTextField = {
        let textField = CustomPaddedTextField()
        textField.placeholder = String(localized: "Новая категория")
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .backgroundSecondary
        textField.setFont(.todoBody)
        return textField
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupAppearance()
        setupLayout()
        setTargetForTextField()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addColorPickerAndLayout(_ view: UIView) {
        addSubviewWithoutAutoresizingMask(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(
                equalTo: textField.bottomAnchor,
                constant: Constants.inset
            ),
            view.leadingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.inset
            ),
            view.trailingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.trailingAnchor,
                constant: -Constants.inset
            ),
            view.heightAnchor.constraint(equalToConstant: Constants.ColorPicker.height)
        ])
    }

    private func setupViews() {
        addSubviewWithoutAutoresizingMask(scrollView)
        scrollView.addSubviewWithoutAutoresizingMask(contentView)
        contentView.addSubviewWithoutAutoresizingMask(textField)
    }

    private func setupAppearance() {
        [self, scrollView, contentView].forEach {
            $0.backgroundColor = .backgroundPrimary
        }
    }

    private func setTargetForTextField() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }

    private func setupLayout() {
        alignSubview(scrollView)
        scrollView.alignSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(
                equalTo: scrollView.safeAreaLayoutGuide.heightAnchor
            ),
            textField.leadingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.inset
            ),
            textField.topAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.topAnchor,
                constant: Constants.inset
            ),
            textField.trailingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.trailingAnchor,
                constant: -Constants.inset
            )
        ])
    }

    @objc private func textFieldChanged(_ textField: UITextField) {
        delegate?.didChangeTextField(text: textField.text ?? "")
    }

}

extension NewCategoryUIView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }

}
