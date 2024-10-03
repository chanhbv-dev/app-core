//
//  ControlEvents.swift
//  Swifty
//
//  Created by chanhbv on 16/9/24.
//

import Foundation
import UIKit

public extension UIControl.Event {
    static let textFieldContentDidChange = UIControl.Event(rawValue: 0x0000_0010)
    static let textFieldDidBeginEditing = UIControl.Event(rawValue: 0x0000_0020)
    static let textFieldDidEndEditing = UIControl.Event(rawValue: 0x0000_0040)

    static let textFieldToggleAction = UIControl.Event(rawValue: 0x0000_0050)

    static let checkboxToggleAction = UIControl.Event(rawValue: 0x0000_0070)
}
