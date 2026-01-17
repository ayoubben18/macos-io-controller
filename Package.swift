// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "macOSIOController",
    platforms: [
        .macOS(.v14)
    ],
    targets: [
        .executableTarget(
            name: "macOSIOController",
            path: "macOSIOController",
            exclude: ["macOSIOController.entitlements"],
            linkerSettings: [
                .linkedFramework("CoreAudio"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("AppKit")
            ]
        )
    ]
)
