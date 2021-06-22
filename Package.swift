// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Segment-Branch",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "Segment-Branch",
            targets: ["Segment-Branch"]
        )
    ],
    dependencies: [
        .package(name: "Branch", url: "https://github.com/BranchMetrics/ios-branch-deep-linking-attribution", from: "1.39.0"),
        .package(name: "Segment", url: "https://github.com/segmentio/analytics-ios", from: "4.1.4")
    ],
    targets: [
        .target(
            name: "Segment-Branch",
            dependencies: ["Branch", "Segment"],
            path: "Pod",
            exclude: ["Example"],
            sources: ["Classes"],
            publicHeadersPath: "."
        )
    ]
)
