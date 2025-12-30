// swift-tools-version:6.2

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "swift-chess",
    products: [
        /*.library(
            name: "swift-chess",
            targets: ["Chess"]
        )*/
    ],
    dependencies: [
        // Macros
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "600.0.1"),

        // UI
        //.package(url: "https://git.aparoksha.dev/aparoksha/adwaita-swift", branch: "main")
    ],
    targets: [
        .macro(
            name: "Macros",
            dependencies: [
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax")
            ]
        ),

        .target(
            name: "ChessKit",
            dependencies: [
                "Macros"
            ]
        ),

        .executableTarget(
            name: "UI",
            dependencies: [
                "ChessKit",
                //.product(name: "Adwaita", package: "adwaita-swift")
            ]
        ),

        .executableTarget(
            name: "Chess",
            dependencies: [
                "ChessKit"
            ]
        ),

        .target(
            name: "Evaluation"
        ),

        .testTarget(
            name: "SwiftChessTests",
            dependencies: ["Chess"]
        )
    ]
)
