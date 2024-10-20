//
//  Array.swift
//  AppCore
//
//  Created by chanhbv on 18/10/24.
//

import Foundation

public extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
