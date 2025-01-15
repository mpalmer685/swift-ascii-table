// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-ascii-table",
  products: [
    .library(name: "AsciiTable", targets: ["AsciiTable"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.17.0"),
  ],
  targets: [
    .target(name: "AsciiTable", dependencies: []),
    .testTarget(
      name: "AsciiTableTests",
      dependencies: [
        "AsciiTable",
        .product(name: "InlineSnapshotTesting", package: "swift-snapshot-testing"),
      ]
    ),
  ]
)
