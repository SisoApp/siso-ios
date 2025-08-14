import SwiftUI

import auth
import coordinator
import profile

@main
struct SisoIosApp: App {
    @StateObject var coordinator: Coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.build(.basic)
                    .navigationDestination(for: AuthPage.self, destination: { page in
                        coordinator.build(page)
                    })
                    .navigationDestination(for: ProfilePage.self) { page in
                        coordinator.build(page)
                    }
            }
            .environmentObject(coordinator)
        }
    }
}
