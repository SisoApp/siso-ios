import SwiftUI

import auth
import coordinator
import profile
import matching

@main
struct SisoIosApp: App {
    @StateObject var userProfile: UserProfile
    @StateObject private var coordinator: Coordinator
    
    @StateObject var matchingViewModel: MatchingViewModel
    @StateObject var authVM: SocialLoginView.LoginViewModel
    @StateObject var locationViewModel: LocationViewModel
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        let userProfile: UserProfile = .init(
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
                coordinator.build(.my)
                //coordinator.start()
                    .navigationDestination(for: IntegrationPage.self, destination: { page in
                        coordinator.build(page)
                    })
                    .sheet(item: $coordinator.profileSheet) { sheet in
                        coordinator.build(sheet: sheet)
                    }
                    .sheet(item: $coordinator.matchingSheet) { sheet in
                        coordinator.build(sheet: sheet)
                    }
            }
            .id(coordinator.stackID)
        }
    }
}
