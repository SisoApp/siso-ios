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
                coordinator.build(.login)
                    .navigationDestination(for: AuthPage.self, destination: { page in
                        coordinator.build(page)
                    })
                    .navigationDestination(for: ProfilePage.self) { page in
                        coordinator.build(page)
                    }
                    .sheet(item: $coordinator.sheet) { sheet in
                        coordinator.build(sheet: sheet)
                    }
                    .fullScreenCover(item: $coordinator.fullScreenCover) { cover in
                        coordinator.build(fullScreenCover: cover)
                    }
            }
            .environmentObject(coordinator)
        }
    }
}
