//
//  Chatting.swift
//  model
//
//  Created by jdios on 9/16/25.
//

import Foundation

public struct Chatting {
    public let id: Int
    // 내가 보낸케이스
    // 상대가 보낸 케이스로
    public let senderId: Int
    public let content: String
    public let createdAt: String
    
}
extension Chatting {
    public init (from: ChatMessageResponseDTO) {
        id = from.id
        senderId = from.senderId
        content = from.content
        createdAt = from.createdAt
    }
}
