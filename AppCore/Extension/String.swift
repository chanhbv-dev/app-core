//
//  String.swift
//  Swifty
//
//  Created by chanhbv on 10/9/24.
//

import CryptoKit
import Foundation

public extension String {
    var asHashed: String {
        let data = Data(utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
