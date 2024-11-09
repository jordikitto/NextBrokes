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
        .package(name: "CoreNetworking", path: "../CoreNetworking")
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
            dependencies: [
                "CoreDesign",
                "CoreNetworking",
                "FeatureRacingData"
            ],
            path: "Sources/Domain",
            swiftSettings: [
                .swiftLanguageMode(.v5) // DateTrigger
            ]
        ),
        .target(
            name: "FeatureRacingData",
            dependencies: ["CoreNetworking"],
            path: "Sources/Data"
        ),
        .testTarget(
            name: "FeatureRacingTests",
            dependencies: ["FeatureRacingPresentation", "FeatureRacingDomain"]
        ),
    ]
)
