// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OakOTPCommon",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "OakOTPCommon",
            targets: ["OakOTPCommon"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/lachlanbell/SwiftOTP.git", .upToNextMinor(from: "3.0.0")),
        .package(url: "https://github.com/hmlongco/Resolver.git", .upToNextMinor(from: "1.4.4")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "OakOTPCommon",
            dependencies: [
                "SwiftOTP",
                "Resolver"
            ]),
        .testTarget(
            name: "OakOTPCommonTests",
            dependencies: ["OakOTPCommon"]),
    ]
)
