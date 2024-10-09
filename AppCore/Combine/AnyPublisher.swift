//
//  AnyPublisher.swift
//  Swifty
//
//  Created by chanhbv on 19/9/24.
//

import Combine
import Foundation

public extension AnyPublisher {
    func handleError<S>(_ subject: S) -> AnyPublisher<Output, Failure> where S: Subject, S.Output == Error {
        self.catch { error -> AnyPublisher<Output, Failure> in
            subject.send(error)
            return self
        }
        .eraseToAnyPublisher()
    }

    func handleErrorThenCatch<S>(_ subject: S) -> AnyPublisher<Output, Never> where S: Subject, S.Output == Error {
        self.catch { error -> AnyPublisher<Output, Never> in
            subject.send(error)
            return AnyPublisher<Output, Never>(Empty())
        }
        .eraseToAnyPublisher()
    }

    func handleLoading<S>(_ subject: S) -> AnyPublisher<Output, Failure> where S: Subject, S.Output == Bool {
        handleEvents(
            receiveSubscription: { _ in
                subject.send(true)
            }, receiveOutput: { _ in
            }, receiveCompletion: { _ in
                subject.send(false)
            }
        )
        .eraseToAnyPublisher()
    }

    func receiveOnMain() -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
