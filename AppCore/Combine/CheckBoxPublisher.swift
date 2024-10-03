//
//  CheckBoxPublisher.swift
//  Swifty
//
//  Created by chanhbv on 17/9/24.
//

import Combine
import Foundation
import UIKit

public extension CheckBox {
    var isCheckedPublisher: AnyPublisher<Bool, Never> {
        UIControlPublisher(control: self, controlEvents: .checkboxToggleAction)
            .map { $0 as? CheckBox }
            .compactMap { $0?.isChecked }
            .eraseToAnyPublisher()
    }
}
