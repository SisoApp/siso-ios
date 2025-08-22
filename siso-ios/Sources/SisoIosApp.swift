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
    
    init() {
        let userProfile: UserProfile = UserProfile(
            nickname: "", age: "", sex: "", targetSex: "",
            profileImageUrl: [], interests: [], introduce: "",
            religion: "", smoking: "", drinking: "", meeting: [], mbti: "", location: ""
        )
        
        let matchingViewModel: MatchingViewModel = .init(cards: [])
        self._userProfile = StateObject(wrappedValue: userProfile)
       
        self._matchingViewModel = StateObject(wrappedValue: matchingViewModel)
        
        self._coordinator = StateObject(wrappedValue: Coordinator(userProfile: userProfile, matchingViewModel: matchingViewModel))
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.build(.main)
                    .navigationDestination(for: AuthPage.self, destination: { page in
                        coordinator.build(page)
                    })
                    .navigationDestination(for: ProfilePage.self) { page in
                        coordinator.build(page)
                    }
                    .navigationDestination(for: MatchingPage.self, destination: { page in
                        coordinator.build(page)
                    })
                    .sheet(item: $coordinator.profileSheet) { sheet in
                        coordinator.build(sheet: sheet)
                    }
                    .sheet(item: $coordinator.matchingSheet) { sheet in
                        coordinator.build(sheet)
                    }
            }
            .id(coordinator.stackID)
        }
    }
}
