//
//  ViewControllerTransparentNavigator.swift
//  Swifty
//
//  Created by chanhbv on 12/9/24.
//

import Foundation
import UIKit

public class ViewControllerTransparentBehavior: NSObject, ViewControllerBehavior {
    private weak var content: UIView?

    public func viewDidLoad(viewController: UIViewController) {
        content = viewController.view
        if let navigationController = viewController.navigationController {
            navigationController.setNavigationBarHidden(false, animated: false)
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.isTranslucent = true
            navigationController.view.backgroundColor = .clear
        }
    }
}
