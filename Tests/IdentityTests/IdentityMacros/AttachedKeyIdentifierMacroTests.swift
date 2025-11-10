//
//  AttachedKeyIdentifierMacroTests.swift
//  swift-identity
//
//  Created by Óscar Morales Vivó on 11/9/25.
//

import Foundation
import Identity
import SwiftDiagnostics
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling.
// Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(IdentityMacros)
@testable import IdentityMacros

@MainActor
let testAttachedKeyIdentifierMacro: [String: Macro.Type] = [
    "KeyIdentifier": AttachedKeyIdentifierMacro.self
]
#endif

@MainActor
final class AttachedKeyIdentifierMacroTests: XCTestCase {
    func testAttachedMacroSimpleUseExpansion() throws {
        #if canImport(IdentityMacros)
        assertMacroExpansion(
            """
            @KeyIdentifier<String>
            public struct ImageID {}
            """,
            expandedSource: """
            public struct ImageID {

                public init(rawValue: String) {
                    self.rawValue = rawValue
                }

                public typealias RawValue = String

                public var rawValue: String
            }

            extension ImageID: Identifier, CodingKeyRepresentable {
            }
            """,
            macros: testAttachedKeyIdentifierMacro
        )
        #endif
    }

    func testAttachedMacroWithExtraAdoptions() throws {
        #if canImport(IdentityMacros)
        assertMacroExpansion(
            """
            @KeyIdentifier<String> struct ImageID: ResourceID, FileID, MediaID {}
            """,
            expandedSource: """
            struct ImageID: ResourceID, FileID, MediaID {

                init(rawValue: String) {
                    self.rawValue = rawValue
                }

                typealias RawValue = String

                var rawValue: String
            }

            extension ImageID: Identifier, CodingKeyRepresentable {
            }
            """,
            macros: testAttachedKeyIdentifierMacro
        )
        #endif
    }
}

// Type declared here to verify that attached macro actually works.
//
// Cannot be used in a local type.
extension TestStruct {
    @KeyIdentifier<String> struct TestKeyID: SomeProtocol, SomeOtherProtocol {}
}
