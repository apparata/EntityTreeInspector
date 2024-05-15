// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "EntityTreeInspector",
    platforms: [.macOS(.v14), .iOS(.v17), .visionOS(.v1)],
    products: [
        .library(name: "EntityTreeInspector", targets: ["EntityTreeInspector"]),
    ],
    targets: [
        .target(name: "EntityTreeInspector"),
    ]
)
