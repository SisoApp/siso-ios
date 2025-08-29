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
            ]),
            "NSCameraUsageDescription": "프로필 사진을 촬영하기 위해 카메라 접근 권한이 필요합니다.",
            "NSPhotoLibraryUsageDescription": "사진을 업로드하기 위해 갤러리 접근 권한이 필요합니다.",
            "NSMicrophoneUsageDescription": "녹음을 위해 마이크 접근 권한이 필요합니다",
            "SERVER_URL": "$(SERVER_URL)",
            "NSAppTransportSecurity": [
                "NSExceptionDomains": [
                    "13.124.11.3": [
                        "NSExceptionAllowsInsecureHTTPLoads": true,
                        "NSIncludesSubdomains": true,
                    ]
                ]
            ],
            "NSLocationWhenInUseUsageDescription": "현재 위치를 가져오기 위해 위치 접근 권한이 필요합니다.",
            "UIBackgroundModes": [
                "remote-notification"
            ]

        ]
    ),
    sources: ["siso-ios/Sources/**",],
    resources: ["siso-ios/Resources/**"],
    entitlements: .file(path: "siso-ios/SupportingFiles/siso-ios.entitlements"),
    dependencies: [
        .target(name: "auth"),
        .target(name: "network"),
        .target(name: "matching"),
        .target(name: "profile"),
        .target(name: "mypage"),
        .target(name: "coordinator"),
        .target(name: "designSystem"),
        .target(name: "call"),
        .target(name: "chat"),
        .external(name: "FirebaseAnalytics"),
        .external(name: "FirebaseMessaging"),
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
        .target(name: "designSystem"),
        .target(name: "network")
    ]
)

let network: Target = .target(
    name: "network",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).network",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .extendingDefault(
        with: [
            "SERVER_URL": "$(SERVER_URL)"
        ]
    ),
    sources: ["siso-ios/Network/**"],
    dependencies: [
        .external(name: "Alamofire"),
        .target(name: "model")
    ]
)

let matching: Target = .target(
    name: "matching",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).matching",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Matching/**"],
    dependencies: [
        .target(name: "model"),
        .target(name: "network"),
    ]
)

let call: Target = .target(
    name: "call",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).call",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Call/**"],
    dependencies: [
        .target(name: "model"),
        .target(name: "matching"),
        .target(name: "network"),
        
        .xcframework(path: .relativeToRoot("Frameworks/libs/AgoraRtcKit.xcframework")),
        .xcframework(path: .relativeToRoot("Frameworks/libs/aosl.xcframework")),
        .xcframework(path: .relativeToRoot("Frameworks/libs/Agoraffmpeg.xcframework")),
        .xcframework(path: .relativeToRoot("Frameworks/libs/Agorafdkaac.xcframework")),
        
            .xcframework(path: .relativeToRoot("Frameworks/libs/AgoraAiEchoCancellationExtension.xcframework")),
        .xcframework(path: .relativeToRoot("Frameworks/libs/AgoraAiEchoCancellationLLExtension.xcframework")),
        .xcframework(path: .relativeToRoot("Frameworks/libs/AgoraAiNoiseSuppressionExtension.xcframework")),
        .xcframework(path: .relativeToRoot("Frameworks/libs/AgoraAiNoiseSuppressionLLExtension.xcframework")),
        
            .xcframework(path: .relativeToRoot("Frameworks/libs/AgoraAudioBeautyExtension.xcframework")),
        .xcframework(path: .relativeToRoot("Frameworks/libs/AgoraLipSyncExtension.xcframework")),
        .xcframework(path: .relativeToRoot("Frameworks/libs/AgoraSoundTouch.xcframework")),
        .xcframework(path: .relativeToRoot("Frameworks/libs/AgoraSpatialAudioExtension.xcframework"))
    ]
)

let chat: Target = .target(
    name: "chat",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).chat",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Chat/**"],
    dependencies: [
        .target(name: "designSystem"),
    ]
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
        .target(name: "designSystem"),
        .target(name: "network")
    ]
)

let myPage: Target = .target(
    name: "mypage",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).mypage",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/MyPage/**"],
    dependencies: [
        .target(name: "designSystem"),
        .target(name: "profile")
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
        .target(name: "profile"),
        .target(name: "call"),
        .target(name: "model"),
        .target(name: "mypage"),
        .target(name: "chat"),
        
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

let model: Target = .target(
    name: "model",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).model",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Model/**"],
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
        myPage,
        coordinator,
        designSystem,
        model,
        call,
        chat
    ]
)
