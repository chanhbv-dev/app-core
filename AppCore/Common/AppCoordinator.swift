//
//  AppCoordinator.swift
//  AppCore
//
//  Created by chanhbv on 9/10/24.
//

import Combine
import Foundation
import UIKit

public protocol Coordinator {
    associatedtype Dependence
    associatedtype Destination

    var navController: UINavigationController { get set }

    func start()
    func navigate(to: Destination)
}
