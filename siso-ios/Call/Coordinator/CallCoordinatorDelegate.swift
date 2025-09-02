//
//  CallDelegate.swift
//  call
//
//  Created by jdios on 8/19/25.
//

import Foundation
import network

public protocol CallCoordinatorDelegate: AnyObject {
    
    func pushCall(_ call: CallPage)
    
    func pop()
    
    func popToRoot()
    
    func dismissCallFlow()
    
    func callToHome()
    
    func popToRootAndGoToChat() // 채팅방 이동 함수
    
}

