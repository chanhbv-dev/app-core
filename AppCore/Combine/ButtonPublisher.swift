//
//  ButtonPublisher.swift
//  AppCore
//
//  Created by chanhbv on 9/10/24.
//

import Combine
import UIKit

public extension UIButton {
    func publisher(for events: UIControl.Event) -> AnyPublisher<Void, Never> {
        return UIControlPublisher(control: self, controlEvents: events)
            .flatMap { _ in Just(()) }
            .eraseToAnyPublisher()
    }
}
