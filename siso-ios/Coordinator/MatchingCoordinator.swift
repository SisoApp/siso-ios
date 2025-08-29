import SwiftUI
import Foundation
import auth
import profile
import matching
import network
import model

extension Coordinator {
    
    // MARK: Page Conversion
    private func toIntegrationPage(_ page: MatchingPage) -> IntegrationPage {
        switch page {
        case .tutorial: return .home
        case .home: return .tutorial
        }
    }
    
    // MARK: MatchingCoordinator Delegate Method
   
    public func pushMatching(_ page: MatchingPage) {
        print("Push Matching \(page)")
        path.append(toIntegrationPage(page))
    }
    
    // 변소
    public func changeMatchingToAuth() {
        path.removeLast(path.count)
        stackID = UUID() // NavigationStack을 강제로 새로고침
    }

    public func changeMatchingToProfile() {
        print("goto profile")
        path.append(IntegrationPage.profile)
    }
    
    public func changeMatchingToCall(opponentProfile: MatchingProfile) {
        print("Call operation launched")
        print("콜함수 씨발아 호출되라고 2 \(opponentProfile.nickname)")
        matchingPath.append(IntegrationPage.manner(opponentProfile: opponentProfile))
        print(matchingPath.count)
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
