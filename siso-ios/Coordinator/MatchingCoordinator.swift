import SwiftUI
import Foundation
import auth
import profile
import matching
import network
import model

extension Coordinator: @preconcurrency MatchingCoordinatorDelegate {
    
    // MARK: Page Conversion
    private func toIntegrationPage(_ page: MatchingPage) -> IntegrationPage {
        switch page {
        case .tutorial: return .tutorial
        case .home: return .home
        case .notification:
            return .notificationCommon
        }
    }
    
    // MARK: MatchingCoordinator Delegate Method
   
    public func pushMatching(_ page: MatchingPage) {
        print("Push Matching \(page)")
        matchingPath.append(toIntegrationPage(page))
    }
    
    // 변소
    public func changeMatchingToAuth() {
        path.removeLast(path.count)
        stackID = UUID() // NavigationStack을 강제로 새로고침
    }

    public func changeMatchingToProfile() {
        print("goto profile")
        matchingPath.append(IntegrationPage.profile)
    }
    
    public func changeMatchingToCall(opponentProfile: MatchingProfile) {
        matchingPath.append(IntegrationPage.manner(opponentProfile: opponentProfile))
        
    }
    
    @ViewBuilder
    public func build(sheet: MatchingSheet) -> some View {
        switch sheet {
        case .fullScreenProfile:
            if let nowWatching = nowWatching {
                FullScreenProfileView(cardViewModel: nowWatching)
            }
        }
    }
}
