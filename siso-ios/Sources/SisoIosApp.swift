import SwiftUI

import auth
import coordinator
import profile

@main
struct SisoIosApp: App {
    @StateObject var userProfile: UserProfile
    @StateObject private var coordinator: Coordinator
    
    init() {
        let userProfile: UserProfile = UserProfile(
            nickname: "", age: "", sex: "", targetSex: "",
            profileImageUrl: [], interests: [], introduce: "", voice: ""
        )
        
        self._userProfile = StateObject(wrappedValue: userProfile)
        self._coordinator = StateObject(wrappedValue: Coordinator(userProfile: userProfile))
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.build(.interest)
                    .navigationDestination(for: AuthPage.self, destination: { page in
                        coordinator.build(page)
                    })
                    .navigationDestination(for: ProfilePage.self) { page in
                        coordinator.build(page)
                    }
                    .sheet(item: $coordinator.profileSheet) { sheet in
                        coordinator.build(sheet: sheet)
                    }
            }
            .id(coordinator.stackID)
        }
    }
}
