// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Script.swift",
    products: [
        .library(
            name: "ScriptSwift",
            targets: ["ScriptSwift"])
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0"),
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "ScriptSwift",
            dependencies: ["ShellOut", "Files"]),
        .testTarget(
            name: "ScriptSwiftTests",
            dependencies: ["ScriptSwift"],
            resources: [
                .process("Fixtures")
            ])
    ]
)