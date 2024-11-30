// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "Example",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "Example", targets: ["Target"] )
    ],
    targets: [
        .target(name: "Target",
            dependencies: [
                "Dep"
            ]
        ),
        .systemLibrary(name: "Lib",
            pkgConfig: "lib",
            providers: [
                .brew(["lib"]),
                .apt(["lib-dev"])
            ])
    ],
    swiftLanguageVersions: [.v5]
)
