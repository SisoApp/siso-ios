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
        case .tutorial: return .home
        case .home: return .tutorial
        case .profileWriteDemand: return .profileWriteDemand
        }
    }
    
    // MARK: MatchingCoordinator Delegate Method
   
    public func pushMatching(_ page: MatchingPage) {
        print("Push Matching \(page)")
        path.append(toIntegrationPage(page))
    }
    
    public func changeMatchingToCall() {
        stackID = UUID()
        path = NavigationPath()
        Task { @MainActor in
            try await Task.sleep(nanoseconds: 50_000_000)
            withAnimation(.easeInOut) {
                
            }
        }
    }
    
    public func changeMatchingToAuth() {
        path.removeLast(path.count)
        stackID = UUID() // NavigationStack을 강제로 새로고침
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
