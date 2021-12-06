// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "advent21",
    platforms: [.macOS(.v11)],
    targets: [
        .executableTarget(
            name: "advent21",
            resources: [.copy("input1.txt"),
                        .copy("input2.txt"),
                        .copy("input3.txt"),
                        .copy("input4.txt"),
                        .copy("input5.txt"),
                        .copy("input6.txt"),
                       ]
        )
    ]
)
