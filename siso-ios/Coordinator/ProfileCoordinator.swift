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
        case .complete: return .complete
        case .location: return .location
        case .religion: return .religion
        case .smoke: return .smoke
        case .drink: return .drink
        case .personality: return .personality
        case .meeting: return .meeting
        case .profile: return .profile
        case .signUp: return .signUp
        case .interest: return .interest
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
        path.append(IntegrationPage.home)
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
        case .location:
            LocationProfileSheet(delegate: self, viewModel: locationViewModel)
        }
    }
}
