// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "KEDebugKit",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "KEDebugKit",
            targets: ["KEDebugKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/kaiengelhardt/kefoundation.git",
            from: "0.0.1"
        ),
        .package(
            url: "https://github.com/kaiengelhardt/keuikit.git",
            from: "0.0.1"
        ),
    ],
    targets: [
        .target(
            name: "KEDebugKit",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "KEDebugKit Unit Tests",
            dependencies: ["KEDebugKit"],
            path: "Unit Tests"
        ),
    ]
)
