// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FeatureRacing",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "FeatureRacing",
            targets: [
                "FeatureRacingPresentation",
                "FeatureRacingDomain"
            ]
        ),
    ],
    dependencies: [
        .package(name: "CoreDesign", path: "../CoreDesign"),
    ],
    targets: [
        .target(
            name: "FeatureRacingPresentation",
            dependencies: [
                "FeatureRacingDomain",
                "CoreDesign"
            ],
            path: "Sources/Presentation"
        ),
        .target(
            name: "FeatureRacingDomain",
            dependencies: ["CoreDesign"],
            path: "Sources/Domain"
        ),
        .target(
            name: "FeatureRacingData",
            path: "Sources/Data"
        ),
        .testTarget(
            name: "FeatureRacingTests",
            dependencies: ["FeatureRacingPresentation", "FeatureRacingDomain"]
        ),
    ]
)
