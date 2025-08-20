//
//  File.swift
//  matching
//
//  Created by jdios on 8/16/25.
//

import SwiftUI

public protocol MatchingCoordinatorDelegate: AnyObject {
    /// 메인 뷰로 이동하고 그때까지 쌓인 스택 해제 
    func popToMainView()
    
    /// 전화하기 버튼 선택 -> ContactingView로 진행
    func pushContactingView()
    
    /// 메시지 보내기 버튼 선택
    func pushChatView()
    
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
