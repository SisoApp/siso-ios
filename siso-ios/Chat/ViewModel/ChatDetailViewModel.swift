//
//  ChatDetailViewModel.swift
//  chat
//
//  Created by jdios on 9/16/25.
//

import Foundation
import network
import model

enum MessageType {
    case sender
    case receiver
}

class ChatDetailViewModel: ObservableObject {
    @Published var messages: [ChatMessageResponseDTO] = []
    let chatNetworkManager: ChatNetwork  = .init()
    
    func sendMessage(chatRoomId: Int, content: String) {
        chatNetworkManager.messageSend(chatRoomId: chatRoomId, content: content)
    }
    
    func getAllMessages(chatRoomId: Int) async throws-> [ChatMessageResponseDTO] {
        return try await chatNetworkManager.getMessages(chatRoomId: chatRoomId)
    }
    
    func getMessageType(_ message: ChatMessageResponseDTO) -> MessageType {
        guard let myUserIdString = KeyChainManager.shared.get(for: "myUserId"),
              let myUserId = Int(myUserIdString) else {
            return .receiver
        }
        
        return message.senderId == myUserId ? .sender : .receiver
    }
}
