//
//  CallDelegate.swift
//  call
//
//  Created by jdios on 8/19/25.
//

import Foundation

public protocol CallCoordinatorDelegate: AnyObject {
    
    /// ContactingView에서 전화 연결됨
    func pushCallingView()
    
    /// 매칭중 전화 걸려오는 경우
    func pushCallInteruptPopup()
    
    /// 전화가 끝나고 이전 화면으로 돌려보내주는 경우
    func finishCallAndPopToPreviousView()
    
    // 전화 끝나고 인연 이어가기 선택 팝업
    func pushKeepConnectionPopup()
}

