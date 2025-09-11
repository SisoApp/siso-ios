import SwiftUI

import auth
import coordinator
import profile
import matching
import model
import call
import network

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
