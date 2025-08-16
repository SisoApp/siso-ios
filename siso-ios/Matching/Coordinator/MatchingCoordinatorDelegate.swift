//
//  File.swift
//  matching
//
//  Created by jdios on 8/16/25.
//

import SwiftUI

public protocol MatchingCoordinatorDelegate: AnyObject {
    /// 전화하기 버튼 선택 -> ContactingView로 진행
    func pushToContactingView()
    
    /// ContactingView에서 전화 연결됨
    func pushToCallingView()
    
    /// 메시지 보내기 버튼 선택
    func pushToChatView()
    
    /// 매칭중 전화 걸려오는 경우
    func pushCallInteruptPopup()
    
    /// 이미지 탭뷰 선택시
    func pushFullScreenProfileImageView()
    
    /// 뒤로가기
    func pop()
    
    /// 뷰 시작지점으로 가기
    func popToRoot()
}

//public protocol MatchingCoordinatorDelegate {
//    func pushProfile(_ page: ProfilePage)
//    func pop()
//    func popToRoot()
//    func buildProfileView(_ page: ProfilePage) -> AnyView
//    func changeProfileToMatching()
//}
