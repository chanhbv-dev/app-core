//
//  TextFieldPublisher.swift
//  Swifty
//
//  Created by chanhbv on 12/9/24.
//

import Combine
import Foundation
import UIKit

public extension UITextField {
    func publisher(for events: UIControl.Event) -> AnyPublisher<String, Never> {
        return UIControlPublisher(control: self, controlEvents: events)
            .map { $0 as? UITextField }
            .compactMap { $0?.text }
            .eraseToAnyPublisher()
    }

    func toggleAction() -> AnyPublisher<Bool, Never> {
        UIControlPublisher(control: self, controlEvents: .textFieldToggleAction)
            .map { $0 as? TextField }
            .compactMap { $0?.isSecureTextEntry }
            .eraseToAnyPublisher()
    }
}

public extension TextFieldGroup {
    var contentPublisher: AnyPublisher<String, Never> {
        UIControlPublisher(control: self, controlEvents: .textFieldContentDidChange)
            .map { $0 as? TextFieldGroup }
            .compactMap { $0?.content }
            .eraseToAnyPublisher()
    }

    var beginEditingPublisher: AnyPublisher<Void, Never> {
        UIControlPublisher(control: self, controlEvents: .textFieldDidBeginEditing)
            .flatMap { _ in Just(()) }.eraseToAnyPublisher()
    }

    var endEditingPublisher: AnyPublisher<Void, Never> {
        UIControlPublisher(control: self, controlEvents: .textFieldDidEndEditing)
            .flatMap { _ in Just(()) }.eraseToAnyPublisher()
    }
}
