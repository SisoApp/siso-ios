import ProjectDescription

let bundleId = "io.tuist.siso-ios"
let appName: Plist.Value = "시소" // 앱 이름
let appVersion: Plist.Value = "1.0.0" // 앱 배포 버젼

let sisoApp: Target = .target(
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
            "CFBundleShortVersionString": appVersion,
            "CFBundleVersion": "20250811",  // inner build number
            "CFBundleDisplayName": appName,
            "CFBundleURLTypes": [
                [
                    "CFBundleURLName": "com.kakao.sdk",
                    "CFBundleURLSchemes": [
                        "kakao$(KAKAO_API_KEY)"
                    ]
                ]
            ],
            "LSApplicationQueriesSchemes": [
                "kakaokompassauth",
            ]
        ]
    ),
    sources: ["siso-ios/sources/**",],
    resources: ["siso-ios/Resources/**"],
    dependencies: [
        .target(name: "auth"),
        .target(name: "network")
    ]
)

let sisoAppTest: Target = .target(
    name: "siso-iosTests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "\(bundleId).siso-iosTests",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Tests/**"],
    resources: [],
    dependencies: [.target(name: "siso-ios")]
)

let auth: Target = .target(
    name: "auth",
    destinations: .iOS,
    product: .framework,
    bundleId: "\(bundleId).auth",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .extendingDefault(
        with: [
            "KAKAO_API_KEY": "$(KAKAO_API_KEY)",
        ]
    ),
    sources: ["siso-ios/Auth/**"],
    dependencies: [
        .external(name: "KakaoSDKCommon"),
        .external(name: "KakaoSDKAuth"),
        .external(name: "KakaoSDKUser")
    ]
)

let network: Target = .target(
    name: "network",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).network",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Network/**"],
    dependencies: []
)

let matching: Target = .target(
    name: "matching",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).matching",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Matching/**"],
    dependencies: []
)

let profile: Target = .target(
    name: "profile",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).profile",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Profile/**"],
    dependencies: []
)
// -------

let project = Project(
    name: "siso-ios",
    settings: .settings(
        base: [:],
        configurations: [
            .debug(
                name: "Debug",
                xcconfig: .relativeToRoot("Configuration/Debug.xcconfig")
            ),
            .release(
                name: "Release",
                xcconfig: .relativeToRoot("Configuration/Release.xcconfig")
            )
        ]
    ),
    targets: [
        sisoApp,
        sisoAppTest,
        auth,
        network,
        matching,
        profile,
    ]
)
