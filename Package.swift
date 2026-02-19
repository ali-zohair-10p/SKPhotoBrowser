// swift-tools-version:5.3
//
//  Package.swift
//

import PackageDescription

let package = Package(
    name: "SKPhotoBrowserKit",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "SKPhotoBrowserKit",
            targets: ["SKPhotoBrowserKit"])
    ],
    targets: [
        .target(
            name: "SKPhotoBrowserKit",
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
            name: "SKPhotoBrowserKitTests",
            dependencies: ["SKPhotoBrowserKit"],
            path: "SKPhotoBrowserTests",
            exclude: ["Info.plist"]
        )
    ]
)
