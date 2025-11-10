//
//  Identifier+UUID.swift
//  swift-identity
//
//  Created by Óscar Morales Vivó on 3/21/23.
//

import Foundation

public extension Identifier where RawValue == UUID {
    /// Simple factory method for `UUID`-based identifiers.
    ///
    /// For UUID-based ``Identifier`` types we either copy them around or generate unique ones on demand. This method
    /// takes care of the latter without having to actually deal with `UUID` itself. The explicit generation is also
    /// more readable.
    /// - Returns: A new unique value of the `UUID`-based identifier.
    static func unique() -> Self {
        .init(rawValue: UUID())!
    }
}

public extension Identifier where RawValue == UUID, Self: Encodable {
    /// Default `Encodable` implementation for `UUID`-backed ``Identifier`` types.
    ///
    /// Many REST APIs use `UUID` identifiers as `String` and usually expect a lowercase uuid string. Having this as the
    /// default encoding saves some additional work integrating `UUID`-backed ``Identifier`` types with REST data flows.
    /// - Parameter encoder: The encoder. Might occasionally be somthing other than `JSONEncoder`.
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue.uuidString.lowercased())
    }
}

public extension Identifier where RawValue == UUID, Self: CustomStringConvertible {
    /// Default `CustomStringConvertible` implementation for `UUID`-backed ``Identifier`` types.
    ///
    /// For sanity's sake, UUID-backed ``Identifier`` types will convert to lowercase strings.
    var description: String {
        rawValue.uuidString.lowercased()
    }
}

public extension Identifier where RawValue == UUID, Self: CodingKeyRepresentable {
    /// Default conformance of UUID-backed ``Identifier`` types to `CodingKeyRepresentable`
    ///
    /// We translate to/from the lowercase `UUID.uuidString` as per the policy of the other default conformances.
    init?(codingKey: some CodingKey) {
        guard let uuid = UUID(uuidString: codingKey.stringValue) else {
            return nil
        }

        self.init(rawValue: uuid)
    }

    var codingKey: any CodingKey {
        rawValue.uuidString.lowercased().codingKey
    }
}
