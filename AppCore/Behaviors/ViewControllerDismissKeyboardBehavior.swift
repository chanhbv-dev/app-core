//
//  ViewControllerDismissKeyboardBehavior.swift
//  Swifty
//
//  Created by chanhbv on 12/9/24.
//

import Foundation
import UIKit

public class ViewControllerDismissKeyboardBehavior: NSObject, ViewControllerBehavior {
    private weak var content: UIView?

    public func viewDidLoad(viewController: UIViewController) {
        content = viewController.view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doDismissKeyboard))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        viewController.view.addGestureRecognizer(tapGesture)
    }

    @objc private func doDismissKeyboard() {
        content?.endEditing(true)
    }
}

extension ViewControllerDismissKeyboardBehavior: UIGestureRecognizerDelegate {
    // TODO: Check if needed to add more UIControl which can not dismiss keyboard when tap
    public func gestureRecognizer(_: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        for _class in [UIColor.self, UINavigationItem.self] where touch.view?.isKind(of: _class) == true {
            return false
        }
        return true
    }
}
