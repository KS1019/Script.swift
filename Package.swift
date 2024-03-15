// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Script.swift",
    products: [
        .library(
            name: "Scripting",
            targets: ["Scripting"])
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0"),
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "Scripting",
            dependencies: ["ShellOut", "Files"]),
        .testTarget(
            name: "ScriptingTests",
            dependencies: ["Scripting"],
            resources: [
                .process("Fixtures")
            ])
    ]
)
