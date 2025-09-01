//
//  Chat.swift
//  siso-ios
//
//  Created by 김용해 on 8/20/25.
//
import SwiftUI

public struct RecentChat: Identifiable {
    public let id: UUID = UUID()
    let userName: String
    let icon: String
    let time: Date
    let hasMessages: Bool
    let recentMessage: String = "채팅방이 개설되었습니다."
    
    public init(userName: String, icon: String, time: Date, hasMessages: Bool) {
        self.userName = userName
        self.icon = icon
        self.time = time
        self.hasMessages = hasMessages
    }
}
