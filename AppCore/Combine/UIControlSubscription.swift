//
//  UIControlSubscription.swift
//  Swifty
//
//  Created by chanhbv on 12/9/24.
//

import Combine
import Foundation
import UIKit

final class UIControlSubscription<S: Subscriber, C: UIControl>: Subscription where S.Input == C {
    private var subscriber: S?
    private var control: C

    init(subscriber: S?, control: C, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(handleControlEvent), for: event)
    }

    func request(_: Subscribers.Demand) {}

    func cancel() {
        subscriber = nil
    }

    @objc func handleControlEvent(_: UIControl.Event) {
        _ = subscriber?.receive(control)
    }
}
