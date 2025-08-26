import SwiftUI
import Foundation
import auth
import profile
import matching
import network

extension Coordinator: @preconcurrency ProfileCoordinatorDelegate {
    
    // ** Page Conversion
    private func toIntegrationPage(_ page: ProfilePage) -> IntegrationPage {
        switch page {
        case .basic: return .basic
        case .interest: return .interest
        case .image: return .image
        case .introduce: return .introduce
        case .record: return .record
        case .complete: return .complete
        }
    }

    // Profile Page
    public func pushProfile(_ page: ProfilePage) {
        path.append(toIntegrationPage(page))
    }
    
    public func pushFullScreenProfileImageView() {
        print("작성예정")
    }
    
    public func changeProfileToMatching() {
        stackID = UUID()
        path = NavigationPath()
        
        Task { @MainActor in
            try await Task.sleep(nanoseconds: 50_000_000)
            withAnimation(.easeInOut) {
                //TODO: 홈으로 보내기
            }
        }
    }
    
    public func presentProfile(sheet: ProfileSheet) {
        profileSheet = sheet
    }
    
    public func dismissProfileSheet() {
        profileSheet = nil
    }
    
    @ViewBuilder
    public func build(sheet: ProfileSheet) -> some View {
        switch sheet {
        case .imageHelper(let completion):
            ImageHelperSheet(delegate: self, userProfile: userProfile, completion: completion)
        case .cameraSheet:
            ImagePicker(userProfile: userProfile)
        }
    }
}
