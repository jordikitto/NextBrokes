// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FeatureRacing",
    defaultLocalization: "en",
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
        .package(name: "CoreNetworking", path: "../CoreNetworking"),
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", branch: "stable")
    ],
    targets: [
        .target(
            name: "FeatureRacingPresentation",
            dependencies: [
                "FeatureRacingDomain",
                "CoreDesign",
                .product(name: "SFSafeSymbols", package: "sfsafesymbols")
            ],
            path: "Sources/Presentation",
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
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
                .swiftLanguageMode(.v5)
            ]
        ),
        .target(
            name: "FeatureRacingData",
            dependencies: ["CoreNetworking"],
            path: "Sources/Data"
        ),
        .testTarget(
            name: "FeatureRacingTests",
            dependencies: [
                "FeatureRacingPresentation",
                "FeatureRacingDomain"
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        ),
    ]
)
