// swift-tools-version:5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "swift-chess",
    products: [
        .library(
            name: "swift-chess",
            targets: ["SwiftChess"]
        )
    ],
    dependencies: [
        // Macros
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "600.0.1"),

        // UI
        //.package(url: "https://git.aparoksha.dev/aparoksha/adwaita-swift", from: "0.1.0")
    ],
    targets: [
        .macro(
            name: "SwiftChessMacros",
            dependencies: [
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax")
            ]
        ),

        .target(
            name: "SwiftChessUtilities",
            dependencies: [
                "SwiftChessMacros"
            ]
        ),

        .executableTarget(
            name: "SwiftChessUI",
            dependencies: [
                "SwiftChessUtilities",
                //.product(name: "Adwaita", package: "adwaita-swift")
            ]
        ),

        .target(
            name: "SwiftChess",
            dependencies: [
                "SwiftChessUtilities"
            ]
        ),

        .target(
            name: "SwiftChessEvaluation"
        ),

        .testTarget(
            name: "SwiftChessTests",
            dependencies: ["SwiftChess"]
        )
    ]
)
