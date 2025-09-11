import ProjectDescription

let bundleId = "io.tuist.siso-ios"
let appName: Plist.Value = "시팅"
let appVersion: Plist.Value = "1.0.0"
// ✨ 1. Agora 프레임워크 의존성을 별도의 변수로 분리합니다.
let agoraDependencies: [TargetDependency] = [
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
// =============================================================================
// App Target
// =============================================================================

let sisoApp: Target = .target(
    name: "siso-ios",
    destinations: .iOS,
    product: .app,
    bundleId: bundleId,
    deploymentTargets: .iOS("17.0"),
    infoPlist: .extendingDefault(
        with: [
            "UILaunchScreen": [:],
            "CFBundleShortVersionString": appVersion,
            "CFBundleVersion": "20250811",
            "CFBundleDisplayName": appName,
            "CFBundleURLTypes": [
                ["CFBundleURLName": "com.kakao.sdk", "CFBundleURLSchemes": ["kakao$(KAKAO_API_KEY)"]]
            ],
            "LSApplicationQueriesSchemes": ["kakaokompassauth"],
            "UIAppFonts": .array([.string("JejuMyeongjoOTF.otf")]),
            "NSCameraUsageDescription": "프로필 사진을 촬영하기 위해 카메라 접근 권한이 필요합니다.",
            "NSPhotoLibraryUsageDescription": "사진을 업로드하기 위해 갤러리 접근 권한이 필요합니다.",
            "NSMicrophoneUsageDescription": "녹음을 위해 마이크 접근 권한이 필요합니다",
            "SERVER_URL": "$(SERVER_URL)",
            "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
            "NSLocationWhenInUseUsageDescription": "현재 위치를 가져오기 위해 위치 접근 권한이 필요합니다.",
            "UIBackgroundModes": ["remote-notification"],
            "UIUserInterfaceStyle": "Light",
            "SOKET_URL": "$(SOKET_URL)",
        ]
    ),
    sources: ["siso-ios/Sources/**"],
    resources: ["siso-ios/Resources/**"],
    entitlements: .file(path: "siso-ios/SupportingFiles/siso-ios.entitlements"),
    dependencies: [
        .target(name: "coordinator"),
        .target(name: "auth"),
        .target(name: "chat"),
        
        // ✨ 최종 앱에 포함될 모든 외부 라이브러리를 명시합니다.
        .external(name: "FirebaseAnalytics"),
        .external(name: "FirebaseMessaging"),
        .external(name: "SwiftStomp"),
        .external(name: "Alamofire"),
        .external(name: "KakaoSDKCommon"),
        .external(name: "KakaoSDKAuth"),
        .external(name: "KakaoSDKUser"),
        // .external(name: "Reachability") // 필요하다면 여기에 추가
    ] + agoraDependencies,
    settings: .settings(base: ["OTHER_LDFLAGS": "-ObjC"])
)

// =============================================================================
// Feature & Core Targets
// =============================================================================

let auth: Target = .target(
    name: "auth",
    destinations: .iOS,
    product: .staticLibrary, // 👈 핵심 수정: .framework -> .staticLibrary
    bundleId: "\(bundleId).auth",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .extendingDefault(with: ["KAKAO_API_KEY": "$(KAKAO_API_KEY)"]),
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
    product: .staticLibrary, // 👈 핵심 수정: .framework -> .staticLibrary
    bundleId: "\(bundleId).network",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .extendingDefault(with: ["SERVER_URL": "$(SERVER_URL)"]),
    sources: ["siso-ios/Network/**"],
    dependencies: [
        .external(name: "Alamofire"),
        .external(name: "SwiftStomp"),
        // .external(name: "Reachability"), // 만약 사용한다면 여기에 추가
        .target(name: "model")
    ]
)

let chat: Target = .target(
    name: "chat",
    destinations: .iOS,
    product: .staticLibrary, // 👈 핵심 수정: .framework -> .staticLibrary
    bundleId: "\(bundleId).chat",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Chat/**"],
    dependencies: [
        .external(name: "SwiftStomp"),
        .target(name: "designSystem"),
        .target(name: "network"),
        .target(name: "model"),
        .target(name: "call")
    ]
)

// --- 순수 코드 모듈들도 모두 .staticLibrary로 통일 ---

let matching: Target = .target(
    name: "matching",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).matching",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Matching/**"],
    dependencies: [.target(name: "model"), .target(name: "network"), .target(name: "designSystem")]
)

let notification: Target = .target(
    name: "notification",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).notification",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Notification/**"],
    dependencies: [.target(name: "model"), .target(name: "network"), .target(name: "designSystem")]
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
        
    ] + agoraDependencies
)

let profile: Target = .target(
    name: "profile",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).profile",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Profile/**"],
    dependencies: [.target(name: "designSystem"), .target(name: "network")]
)

let myPage: Target = .target(
    name: "mypage",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "\(bundleId).mypage",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/MyPage/**"],
    dependencies: [.target(name: "designSystem"), .target(name: "profile"), .target(name: "auth")]
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
        .target(name: "auth"), .target(name: "matching"), .target(name: "profile"),
        .target(name: "call"), .target(name: "model"), .target(name: "mypage"),
        .target(name: "chat"), .target(name: "notification")
    ]
)

// --- 리소스가 포함된 모듈은 .framework로 유지 ---

let designSystem: Target = .target(
    name: "designSystem",
    destinations: .iOS,
    product: .framework, // 리소스(폰트, 에셋)가 있다면 framework가 관리하기 더 용이
    bundleId: "\(bundleId).designSystem",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/DesignSystem/**"],
    resources: ["siso-ios/DesignSystem/**"], // 리소스 경로 추가
    dependencies: []
)

let model: Target = .target(
    name: "model",
    destinations: .iOS,
    product: .staticLibrary, // 모델은 순수 코드이므로 static으로
    bundleId: "\(bundleId).model",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Model/**"],
    dependencies: []
)

let sisoAppTest: Target = .target(
    name: "siso-iosTests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "\(bundleId).siso-iosTests",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .default,
    sources: ["siso-ios/Tests/**"],
    dependencies: [.target(name: "siso-ios")]
)

// =============================================================================
// Project Definition
// =============================================================================

let project = Project(
    name: "siso-ios",
    settings: .settings(
        base: [:],
        configurations: [
            .debug(name: "Debug", xcconfig: .relativeToRoot("Configuration/Debug.xcconfig")),
            .release(name: "Release", xcconfig: .relativeToRoot("Configuration/Release.xcconfig"))
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
        chat,
        notification,
    ]
)
