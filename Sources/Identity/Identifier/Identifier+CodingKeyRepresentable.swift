//
//  Identifier+CodingKeyRepresentable.swift
//  swift-identity
//
//  Created by Óscar Morales Vivó on 11/9/25.
//

import Foundation

public extension Identifier where RawValue: CodingKeyRepresentable, Self: CodingKeyRepresentable {
    /// Default conformance of `CodingKeyRepresentable` when the backing type conforms.
    ///
    /// This will work for `String` and `Int`, as well as any other backing types that conform to the protocol.
    ///
    /// The initializer just redirects to the raw value initializer.
    init?(codingKey: some CodingKey) {
        guard let rawValue = RawValue(codingKey: codingKey) else {
            return nil
        }

        self.init(rawValue: rawValue)
    }

    /// Default conformance of `CodingKeyRepresentable` when the backing type conforms.
    ///
    /// This will work for `String` and `Int`, as well as any other backing types that conform to the protocol.
    var codingKey: any CodingKey {
        rawValue.codingKey
    }
}
