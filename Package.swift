// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Autograph",
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
            from: "0.2.1"
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
