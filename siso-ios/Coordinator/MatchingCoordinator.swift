import SwiftUI
import Foundation
import auth
import profile
import matching
import network

extension Coordinator: @preconcurrency MatchingCoordinatorDelegate {
    
    // MARK: Page Conversion
    private func toIntegrationPage(_ page: MatchingPage) -> IntegrationPage {
        switch page {
        case .home: return .home
        case .beCalled: return .beCalled
        case .chat: return .chat
        case .contacting: return .contacting
        case .calling: return .calling
        }
    }
    
    // MARK: MatchingCoordinator Delegate Method
    public func popToMainView() {
        print("poptoMain")
    }
    
    public func pushCallInteruptPopup() {
        matchingSheet = .afterCallPopup
    }
    
    public func buildMatchingView(_ page: MatchingPage) -> AnyView {
        AnyView(build(toIntegrationPage(page)))
    }
    
    public func pushContactingView() {
        path.append(toIntegrationPage(MatchingPage.contacting))
    }
    
    public func pushCallingView() {
        path.append(toIntegrationPage(MatchingPage.calling))
    }
    
    public func pushChatView() {
        path.append(toIntegrationPage(MatchingPage.chat))
    }
    
    public func changeMatchingToAuth() {
        
    }
    
    
    @ViewBuilder
    public func build(_ sheet: MatchingSheet) -> some View {
        switch sheet {
        case .afterCallPopup:
            AfterCallPopup(cardViewModel: matchingViewModel.cards[0])
        }
    }
}
