// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "AutoDock",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/sindresorhus/LaunchAtLogin-Modern", from: "1.1.0")
    ],
    targets: [
        .executableTarget(
            name: "AutoDock",
            dependencies: [
                .product(name: "LaunchAtLogin", package: "LaunchAtLogin-Modern")
            ]
        )
    ]
)
