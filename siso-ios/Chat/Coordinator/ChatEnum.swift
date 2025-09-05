//
//  ChatEnum.swift
//  siso-ios
//
//  Created by 김용해 on 8/20/25.
//

import model

public enum ChatPage: Identifiable, Hashable {
    case main
    case detail(chat: ChatRoomResponseDTO)
    case notificationChat
    
    public var id: String {
        switch self {
        case .main:
            return "main"
        case .detail(let chat):
            return "detail-\(chat.id)"
        case .notificationChat:
            return "notificationChat"
        }
    }
    
    public static func == (lhs: ChatPage, rhs: ChatPage) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public enum ChatSheet: String, Identifiable, Hashable {
    case chat

    public var id: String { self.rawValue }
}
