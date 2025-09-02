import SwiftUI
import Foundation
import auth
import profile
import matching
import network


extension Coordinator: @preconcurrency AuthCoordinatorDelegate {
    public func openSheet(_ sheet: auth.AuthSheet) {
        self.authSheet = sheet
    }
    
    public func dismissSheet() {
        self.authSheet = nil
    }
    
    // MARK: 첫 빌드 시 동의 항목 가면 뒤로가기 없애기
    public func initAuthback() -> Bool {
        path.count <= 1
    }
    
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
        path.append(IntegrationPage.signUp)
    }
    
    public func changeAuthToMatching() {
        pushMatching(.home)
    }
    
    @ViewBuilder
    public func build(sheet: AuthSheet) -> some View {
        switch sheet {
            case .consent(let title ,let content):
                AcceptSheet(title: title ,content: content, delegate: self)
        }
    }
}
