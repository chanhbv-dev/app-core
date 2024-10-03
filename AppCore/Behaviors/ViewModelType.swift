//
//  BaseViewModel.swift
//  Swifty
//
//  Created by chanhbv on 10/9/24.
//

import Combine
import Foundation

public protocol ViewModelType: AnyObject {
//    associatedtype State
    associatedtype Input
    // associatedtype Output = AnyPublisher<State, Never>
    associatedtype Output

    var isLoading: CurrentValueSubject<Bool, Never> { get set }
    var error: PassthroughSubject<Error, Never> { get set }

    func transform(_ input: Input) -> Output
}
