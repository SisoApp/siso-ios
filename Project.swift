import ProjectDescription

let bundleId = "io.tuist.siso-ios"
let appName: Plist.Value = "시팅" // 앱 이름
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
            ],
            "UIAppFonts": .array([
                               .string("JejuMyeongjoOTF.otf"),
                           ])
        ]
    ),
    sources: ["siso-ios/Sources/**",],
    resources: ["siso-ios/Resources/**"],
    dependencies: [
        .target(name: "auth"),
        .target(name: "network"),
        .target(name: "matching"),
        .target(name: "profile"),
        .target(name: "coordinator"),
        .target(name: "designSystem")
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
        .external(name: "KakaoSDKUser"),
        .target(name: "designSystem")
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
    dependencies: [
        .target(name: "designSystem")
    ]
)

let coordinator: Target = .target(
    name: "coordinator",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).coordinator",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Coordinator/**"],
    dependencies: [
        .target(name: "auth"),
        .target(name: "matching"),
        .target(name: "profile")
    ]
)
let designSystem: Target = .target(
    name: "designSystem",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).designSystem",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/DesignSystem/**"],
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
        coordinator,
        designSystem,
    ]
)
