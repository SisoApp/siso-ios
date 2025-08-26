//
//  MyPageCoordinator.swift
//  coordinator
//
//  Created by 멘태 on 8/25/25.
//
import mypage
import profile

extension Coordinator: @preconcurrency MyPageCoordinatorDelegate {
    private func toIntegrationPage(_ page: MyPage) -> IntegrationPage {
        switch page {
        case .my: return .my
        case .setting: return .setting
        case .notification: return .notification
        }
    }
    
    public func pushMyPage(_ page: mypage.MyPage) {
        path.append(toIntegrationPage(page))
    }
    
    public func pushMyPageToProfile() {
        path.append(IntegrationPage.profile)
    }
}
