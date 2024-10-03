//
//  ViewControllerBehavior.swift
//  Swifty
//
//  Created by chanhbv on 12/9/24.
//

import Foundation
import UIKit

public protocol ViewControllerBehavior {
    func viewDidLoad(viewController: UIViewController)
    func viewWillAppear(viewController: UIViewController)
    func viewDidAppear(viewController: UIViewController)
    func viewWillDisappear(viewController: UIViewController)
    func viewDidDisappear(viewController: UIViewController)
}

public extension ViewControllerBehavior {
    func viewDidLoad(viewController _: UIViewController) {}
    func viewWillAppear(viewController _: UIViewController) {}
    func viewDidAppear(viewController _: UIViewController) {}
    func viewWillDisappear(viewController _: UIViewController) {}
    func viewDidDisappear(viewController _: UIViewController) {}
}
