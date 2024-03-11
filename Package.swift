// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DiiaCommonServices",
    defaultLocalization: "uk",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DiiaCommonServices",
            targets: ["DiiaCommonServices"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/diia-open-source/ios-mvpmodule.git", .upToNextMinor(from: Version(1, 0, 0))),
        .package(url: "https://github.com/diia-open-source/ios-network.git", .upToNextMinor(from: Version(1, 0, 0))),
        .package(url: "https://github.com/diia-open-source/ios-uicomponents.git", .upToNextMinor(from: Version(1, 0, 0))),
        .package(url: "https://github.com/diia-open-source/ios-commontypes.git", .upToNextMinor(from: Version(1, 0, 0))),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DiiaCommonServices",
            dependencies: [
                .product(name: "DiiaMVPModule", package: "ios-mvpmodule"),
                .product(name: "DiiaNetwork", package: "ios-network"),
                .product(name: "DiiaUIComponents", package: "ios-uicomponents"),
                .product(name: "DiiaCommonTypes", package: "ios-commontypes"),

            ]),
        .testTarget(
            name: "DiiaCommonServicesTests",
            dependencies: ["DiiaCommonServices"]),
    ]
)
