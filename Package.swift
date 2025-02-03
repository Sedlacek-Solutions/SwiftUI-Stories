// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProgressTabView",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "ProgressTabView",
            targets: ["ProgressTabView"]),
    ],
    targets: [
        .target(
            name: "ProgressTabView"),

    ]
)
