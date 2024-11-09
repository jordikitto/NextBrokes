// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CoreDesign",
    products: [
        .library(
            name: "CoreDesign",
            targets: ["CoreDesign"]),
    ],
    targets: [
        .target(name: "CoreDesign"),
    ]
)
