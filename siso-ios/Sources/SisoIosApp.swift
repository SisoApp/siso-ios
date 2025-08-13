import SwiftUI
import coordinator
import profile

@main
struct SisoIosApp: App {
    @StateObject var coordinator: Coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.build(.basic)
                    .navigationDestination(for: ProfilePage.self) { page in
                        coordinator.build(page)
                    }
            }
            .environmentObject(coordinator)
        }
    }
}
