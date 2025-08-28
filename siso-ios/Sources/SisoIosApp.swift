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
            NavigationStack(path: $coordinator.path) {
                coordinator.start()
                    .navigationDestination(for: IntegrationPage.self, destination: { page in
                        coordinator.build(page)
                    })
                    .sheet(item: $coordinator.profileSheet) { sheet in
                        coordinator.build(sheet: sheet)
                    }
                    .sheet(item: $coordinator.matchingSheet) { sheet in
                        coordinator.build(sheet: sheet)
                    }
                    .sheet(item: $coordinator.callSheet) { sheet in
                        coordinator.build(sheet: sheet)
                    }
                // ✨ [추가] 통화 후 평가 시트를 위한 .sheet 수정자
                    .sheet(item: $coordinator.afterCallSheetProfile) { profile in
                        // afterCallSheetProfile에 값이 할당되면 이 시트가 나타납니다.
                        AfterCallAssessmentView(opponentProfile: profile, matchingDelegate: coordinator)
                    }
            }
            .id(coordinator.stackID)
            .environmentObject(appSettings)
        }
    }
}
