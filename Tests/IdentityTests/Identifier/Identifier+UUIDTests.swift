//
//  Identifier+UUIDTests.swift
//  swift-identity
//
//  Created by Óscar Morales Vivó on 9/3/25.
//

import Foundation
import Identity
import Testing

struct IdentifierUUIDTests {
    #ID<UUID>("TestID")

    @Test("Checks that it converts to lowercase string")
    func convertToLowercaseString() {
        let uuid = UUID()

        let testID = TestID(rawValue: uuid)

        #expect(String(describing: testID) == uuid.uuidString.lowercased())
    }

    @Test("Checks that it encodes to lowercase string")
    func encodeToLowercaseString() throws {
        let uuid = UUID()

        let testID = TestID(rawValue: uuid)

        let data = try JSONEncoder().encode([testID])
        let jsonString = String(data: data, encoding: .utf8)

        #expect(jsonString == "[\"\(uuid.uuidString.lowercased())\"]")
    }

    @Identifier<UUID> struct TestKeyID: CodingKeyRepresentable {}

    @Test("Checks that CodingKeyRepresentable conformance works as intended")
    func codingKeyRepresentableConformance() throws {
        let uuid1 = try #require(UUID(uuidString: "ec71322a-2d12-4d35-83fe-99f70faa7e92"))
        let uuid2 = try #require(UUID(uuidString: "c2cc54c6-86ac-4e1f-95d7-333eb7a7b1ad"))

        let uuidKeyed = [TestKeyID(rawValue: uuid1): "Keyed by UUID 1", TestKeyID(rawValue: uuid2): "Keyed by UUID 2"]

        let encoder = JSONEncoder()
        let data = try encoder.encode(uuidKeyed)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode([String: String].self, from: data)

        #expect(decoded[uuid1.uuidString.lowercased()] == "Keyed by UUID 1")
        #expect(decoded[uuid2.uuidString.lowercased()] == "Keyed by UUID 2")
    }
}
