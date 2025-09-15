import SwiftUI

import auth
import coordinator
import profile
import matching
import model
import call
import network
import KakaoSDKCommon

@main
struct SisoIosApp: App {
  
    
    @StateObject var userProfile: UserProfile
    @StateObject private var coordinator: Coordinator
    @StateObject private var appSettings = AppSettings()
    @StateObject var matchingViewModel: MatchingViewModel
    @StateObject var authVM: SocialLoginView.LoginViewModel
    @StateObject var locationViewModel: LocationViewModel
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        printAllTokens()
        // ⭐️⭐️⭐️ 이 코드가 init()의 가장 처음에 있는지 확인하세요! ⭐️⭐️⭐️
               if let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String {
                   print("✅ Found Kakao App Key in Info.plist: \(kakaoAppKey)")
                   KakaoSDK.initSDK(appKey: kakaoAppKey)
                   print("✅ KakaoSDK.initSDK() called successfully.")
               } else {
                   // 만약 이 로그가 찍힌다면, 1단계 또는 Tuist 설정이 여전히 잘못된 것입니다.
                   fatalError("🚨 KAKAO_NATIVE_APP_KEY not found in Info.plist. Check your Tuist setup and xcconfig files.")
               }
        let userProfile: UserProfile = .init(
            nickname: "", age: 0, sex: "", targetSex: "", profileImageUrl: [],
            interests: [], introduce: "", religion: "", smoking: nil, drinking: "",
            meeting: [], mbti: "", location: "")
        
        let matchingViewModel = MatchingViewModel(cards: [])
        let authViewModel = SocialLoginView.LoginViewModel()
        let locationViewModel: LocationViewModel = .init()
        
        self._userProfile = StateObject(wrappedValue: userProfile)
        self._matchingViewModel = StateObject(wrappedValue: matchingViewModel)
        self._authVM = StateObject(wrappedValue: authViewModel)
        self._locationViewModel = StateObject(wrappedValue: locationViewModel)
        
        self._coordinator = StateObject(
            wrappedValue: Coordinator(
                userProfile: userProfile,
                matchingViewModel: matchingViewModel,
                authViewModel: authViewModel,
                locationViewModel: locationViewModel
            )
        )
        
       
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(coordinator)
                .environmentObject(userProfile)
                .environmentObject(appSettings)
                .environmentObject(matchingViewModel)
                .environmentObject(authVM)
                .environmentObject(locationViewModel)
                .environmentObject(CallManager.shared)
        }
    }
}

func printAllTokens() {
    print("REFRESH TOKEN:")
    print(KeyChainManager.shared.get(for: "refreshToken"))
    
    print("ACCESS TOKEN:")
    print(KeyChainManager.shared.get(for: "accessToken"))
    
    print("FCM TOKEN:")
    print(KeyChainManager.shared.get(for: "fcmToken"))
}
