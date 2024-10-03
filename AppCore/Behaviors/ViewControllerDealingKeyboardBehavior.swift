//
//  ViewControllerDealingKeyboardBehavior.swift
//  Swifty
//
//  Created by chanhbv on 17/9/24.
//

import Foundation
import UIKit

public class ViewControllerDealingKeyboardBehavior: NSObject, ViewControllerBehavior {
    private weak var content: UIView?

    public func viewDidLoad(viewController: UIViewController) {
        content = viewController.view
    }

    public func viewWillAppear(viewController _: UIViewController) {
        subscribeKeyboardNotifications()
    }

    public func viewWillDisappear(viewController _: UIViewController) {
        unSubscribeKeyboardNotifications()
    }

    private func subscribeKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func unSubscribeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo, let content = content,
              let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = content.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height

        if textFieldBottomY > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY + convertedTextFieldFrame.height * 1.75) * -1

            UIView.animate(withDuration: duration) { [weak self] in
                self?.content?.frame.origin.y = newFrameY
                self?.content?.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }

        UIView.animate(withDuration: duration) { [weak self] in
            self?.content?.frame.origin.y = 0
            self?.content?.layoutIfNeeded()
        }
    }
}
