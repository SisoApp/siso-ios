import SwiftUI

import auth
import coordinator
import profile
import matching
import model
import call

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
        let userProfile = UserProfile(
            nickname: "", age: "", sex: "", targetSex: "", profileImageUrl: [],
            interests: [], introduce: "", religion: "", smoking: "", drinking: "",
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
            coordinator.start()
        }
    }
}
