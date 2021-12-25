// swift-tools-version:5.5

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
            name: "KEFoundation",
            url: "https://github.com/kaiengelhardt/kefoundation.git",
            from: "0.1.0"
        ),
    ],
    targets: [
        .target(
            name: "KEDebugKit",
            dependencies: ["KEFoundation"],
            path: "Sources"
        ),
        .testTarget(
            name: "KEDebugKit Unit Tests",
            dependencies: ["KEDebugKit"],
            path: "Unit Tests"
        ),
    ]
)
