// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-identity",
    platforms: [
        .macOS("12.3"),
        .iOS("15.4"),
        .tvOS("15.4"),
        .watchOS("8.5"),
        .visionOS(.v1),
        .macCatalyst("15.4")
    ],
    products: [
        .library(
            name: "Identity",
            targets: ["Identity"]
        )
    ],
    dependencies: [
        // Depend on the Swift 6.0 release of SwiftSyntax
        .package(url: "https://github.com/swiftlang/swift-syntax", "509.0.0" ..< "603.0.0")
    ],
    targets: [
        .macro(
            name: "IdentityMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "Identity",
            dependencies: ["IdentityMacros"]
        ),
        .testTarget(
            name: "IdentityTests",
            dependencies: [
                "Identity",
                "IdentityMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ]
        )
    ]
)
