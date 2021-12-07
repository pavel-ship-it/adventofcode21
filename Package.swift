// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "advent21",
    platforms: [.macOS(.v11)],
    targets: [
        .executableTarget(
            name: "advent21",
            resources: [.copy("Input")]
        )
    ]
)
