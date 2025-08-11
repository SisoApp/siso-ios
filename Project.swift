import ProjectDescription

let bundleId = "io.tuist.siso-ios"
let testBundleId = "io.tuist.siso-iosTests"
let root: Target =  .target(
    name: "siso-ios",
    destinations: .iOS,
    product: .app,
    bundleId: bundleId,
    deploymentTargets: .iOS("17.0"),
    infoPlist: .extendingDefault(
        with: [
            "UILaunchScreen": [
                "UIColorName": "",
                "UIImageName": "",
            ],
        ]
    ),
    sources: ["siso-ios/sources/**",
              "siso-ios/Auth/**",
              "siso-ios/Network/**"],
    
    resources: ["siso-ios/Resources/**"],
    dependencies: [.target(name: "auth"),
                   .target(name: "network")]
)
let auth: Target =  .target(
    name: "auth",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).auth",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Auth/**"],
    dependencies: []
)

let network: Target =  .target(
    name: "network",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).network",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Network/**"],
    dependencies: []
)
let test: Target = .target(
    name: "siso-iosTests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: testBundleId,
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Tests/**"],
    resources: [],
    dependencies: [.target(name: "siso-ios")]
)

let project = Project(
    name: "siso-ios",
    targets: [
        root,
        auth,
        test,
        network,
    ]
)
