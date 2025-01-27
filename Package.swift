// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "swift-chess",
    products: [
        .library(
            name: "swift-chess",
            targets: ["SwiftChess"]
        )
    ],
    targets: [
        .target(
            name: "SwiftChessUtilities"
        ),
        .target(
            name: "SwiftChess",
            dependencies: [
                "SwiftChessUtilities"
            ]
        ),

        .testTarget(
            name: "SwiftChessTests",
            dependencies: ["SwiftChess"]
        )
    ]
)
