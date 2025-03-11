// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Autograph",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "Autograph",
            targets: [
                "Autograph"
            ]
        ),
    ],
    dependencies: [
        .package(
            name: "Synopsis",
            url: "https://github.com/Incetro/synopsis",
            .branch("main")
        )
    ],
    targets: [
        .target(
            name: "Autograph",
            dependencies: [
                "Synopsis"
            ]
        ),
        .testTarget(
            name: "AutographTests",
            dependencies: [
                "Autograph"
            ]
        ),
    ]
)
