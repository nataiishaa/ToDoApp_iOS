//
//  BaseScrollableViewController.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 04.07.2024.
//

import UIKit

protocol BaseScrollableView: AnyObject {
    var scrollView: UIScrollView { get }
}

class BaseScrollableViewController: UIViewController {

    private let baseScrollableView: BaseScrollableView

    private var notificationCenter: NotificationCenter {
        NotificationCenter.default
    }

    // MARK: - Initializers
    init(baseScrollableView: BaseScrollableView) {
        self.baseScrollableView = baseScrollableView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerKeyboardObserver()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObserver()
    }

    private func registerKeyboardObserver() {
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow(notification:)),
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide(notification:)),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
    }

    private func removeKeyboardObserver() {
        notificationCenter.removeObserver(self,
                                          name: UIResponder.keyboardWillShowNotification,
                                          object: nil)
        notificationCenter.removeObserver(self,
                                          name: UIResponder.keyboardWillHideNotification,
                                          object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary,
              let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
        let keyboardSize = keyboardInfo.cgRectValue.size
        baseScrollableView.scrollView.contentInset.bottom = keyboardSize.height
        baseScrollableView.scrollView.verticalScrollIndicatorInsets.bottom = keyboardSize.height
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        baseScrollableView.scrollView.contentInset.bottom = .zero
        baseScrollableView.scrollView.verticalScrollIndicatorInsets.bottom = .zero
    }

}
