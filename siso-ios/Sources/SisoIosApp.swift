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
    
    init() {
        let userProfile = UserProfile(
            nickname: "", age: "", sex: "", targetSex: "",
            profileImageUrl: [], interests: [], introduce: ""
        )
        let matchingViewModel = MatchingViewModel(cards: [])
        let authViewModel = SocialLoginView.LoginViewModel()

        self._userProfile = StateObject(wrappedValue: userProfile)
        self._matchingViewModel = StateObject(wrappedValue: matchingViewModel)
        self._authVM = StateObject(wrappedValue: authViewModel)

        self._coordinator = StateObject(
            wrappedValue: Coordinator(
                userProfile: userProfile,
                matchingViewModel: matchingViewModel,
                authViewModel: authViewModel
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
            }
            .id(coordinator.stackID)
        }
    }
}
