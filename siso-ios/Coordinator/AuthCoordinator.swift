import SwiftUI
import Foundation
import auth
import profile
import matching
import network


extension Coordinator: @preconcurrency AuthCoordinatorDelegate {
    
    
    // MARK: Page Conversion
    private func toIntegrationPage(_ page: AuthPage) -> IntegrationPage {
        switch page {
        case .login: return .login
        case .accept: return .accept
        case .welcome: return .welcome
        }
    }
    
    // MARK: AuthCoordinator Delegate Method
    public func pushAuth(_ page: AuthPage) {
        path.append(toIntegrationPage(page))
    }
    
    public func changeAuthToProfile() {
        stackID = UUID()
        path = NavigationPath()
        
        Task { @MainActor in
            try await Task.sleep(nanoseconds: 50_000_000)
            withAnimation(.easeInOut) {
                pushProfile(.signUp)
            }
        }
    }
    
    public func changeAuthToMatching() {
        stackID = UUID()
        path = NavigationPath()
        
        Task { @MainActor in
            try await Task.sleep(nanoseconds: 50_000_000)
            withAnimation(.easeInOut) {
                
            }
        }
    }
    
    // MARK: App Start func
    @ViewBuilder
    public func start() -> some View {
        // 이제 start() 함수는 InitialView를 반환하여 비동기 처리를 위임합니다.
        InitialView()
            .environmentObject(self) // self(Coordinator)를 주입
            .environmentObject(self.authViewModel) // authViewModel을 주입
            .environmentObject(self.appSettings)
    }
}
