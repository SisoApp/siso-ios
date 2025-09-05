// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
    // Customize the product types for specific package product
    // Default is .staticFramework
    productTypes: [
        "Alamofire" : .framework,
        "KakaoOpenSDK" : .framework,
        "SwiftStomp" : .staticLibrary
    ]
)
#endif

let package = Package(
    name: "siso-ios",
    dependencies: [
        // Kakao SDK
        .package(url: "https://github.com/Alamofire/Alamofire", "5.9.1"..."6.0.0"),
        .package(
            url: "https://github.com/kakao/kakao-ios-sdk.git",
            exact: "2.24.6"
        ),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "12.1.0"),
        .package(url: "https://github.com/Romixery/SwiftStomp.git", from: "1.2.1")
    ]
)
