import ProjectDescription

let project = Project(
    name: "siso-ios",
    targets: [
        .target(
            name: "siso-ios",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.siso-ios",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["siso-ios/Sources/**"],
            resources: ["siso-ios/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "siso-iosTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.siso-iosTests",
            infoPlist: .default,
            sources: ["siso-ios/Tests/**"],
            resources: [],
            dependencies: [.target(name: "siso-ios")]
        ),
    ]
)
