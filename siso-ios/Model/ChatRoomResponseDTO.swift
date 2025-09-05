//
//  ChatRoomResponseDTO.swift
//  network
//
//  Created by 김용해 on 9/3/25.
//

import Foundation


public struct ChatRoomResponseDTO: Codable, Identifiable {
    public let id: Int
    public let otherUserNickName: String
    public let otherUserProfileImagePath: String
    public let memberCount: Int
    public let lastMessageContent: String
    public let lastMessageSentAt: String
    public let unreadMessageCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case otherUserNickName = "otherUserNickname"
        case otherUserProfileImagePath = "otherUserProfileImagePath"
        case memberCount = "memberCount"
        case lastMessageContent = "lastMessageContent"
        case lastMessageSentAt = "lastMessageSentAt"
        case unreadMessageCount = "unreadMessageCount"
    }
    
}
