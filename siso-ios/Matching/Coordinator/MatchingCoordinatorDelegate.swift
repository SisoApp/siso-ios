//
//  File.swift
//  matching
//
//  Created by jdios on 8/16/25.
//

import SwiftUI

public protocol MatchingCoordinatorDelegate: AnyObject {
    
    func pushMatching(_ page: MatchingPage)
    
    /// 뒤로가기
    func pop()
    
    /// 뷰 시작지점으로 가기
    func popToRoot()
    
    func changeMatchingToAuth()
    /// 전화로 전환
    func changeMatchingToCall()
}

