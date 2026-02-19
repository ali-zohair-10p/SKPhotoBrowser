// swift-tools-version:5.3
//
//  Package.swift
//

import PackageDescription

let package = Package(
    name: "SKPhotoBrowser",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "SKPhotoBrowser",
            targets: ["SKPhotoBrowser"])
    ],
    targets: [
        .target(
            name: "SKPhotoBrowser",
            dependencies: [],              // no more SKPhotoBrowserObjC
            path: "SKPhotoBrowser",
            exclude: [
                "Info.plist",
                "extensions/ObjC"          // exclude the old ObjC files
            ],
            resources: [
                .copy("SKPhotoBrowser.bundle")
            ]
        ),
        // SKPhotoBrowserObjC target removed
        .testTarget(
            name: "SKPhotoBrowserTests",
            dependencies: ["SKPhotoBrowser"],
            path: "SKPhotoBrowserTests",
            exclude: ["Info.plist"]
        )
    ]
)
