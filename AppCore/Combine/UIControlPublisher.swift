//
//  UIControlPublisher.swift
//  Swifty
//
//  Created by chanhbv on 12/9/24.
//

import Combine
import Foundation
import UIKit

protocol CombineCompatible {}
extension UIControl: CombineCompatible {}

struct UIControlPublisher: Publisher {
    typealias Output = UIControl
    typealias Failure = Never

    private let control: UIControl
    private let controlEvents: UIControl.Event

    init(control: UIControl, controlEvents: UIControl.Event) {
        self.control = control
        self.controlEvents = controlEvents
    }

    func receive<S>(subscriber: S) where S: Subscriber, S.Failure == UIControlPublisher.Failure, S.Input == UIControlPublisher.Output {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: controlEvents)
        subscriber.receive(subscription: subscription)
    }
}

extension CombineCompatible where Self: UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher {
        return UIControlPublisher(control: self, controlEvents: events)
    }

    func publisher(for events: UIControl.Event) -> AnyPublisher<Void, Never> {
        return UIControlPublisher(control: self, controlEvents: events).flatMap { _ in Just(()) }.eraseToAnyPublisher()
    }
}