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
        case .voice: return .voice
        case .image: return .image 
        }
    }

    // Profile Page
    public func pushProfile(_ page: ProfilePage) {
        if selectedTab == 2 {
            // 마이페이지에서 프로필 화면을 보여줄 때
            myPagePath.append(toIntegrationPage(page))
        } else {
            // 최초 로그인 시점에 프로필을 등록할 때
            path.append(toIntegrationPage(page))
        }
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
        case .religion:
            ReligionProfileSheet(delegate: self, userProfile: userProfile)
        }
    }
}
