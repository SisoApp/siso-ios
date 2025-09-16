//
//  ChatDetailViewModel.swift
//  chat
//
//  Created by jdios on 9/16/25.
//

import Foundation
import network
import model
class ChatDetailViewModel: ObservableObject {
    @Published var messages: [ChatMessageResponseDTO] = []
    let chatNetworkManager: ChatNetwork  = .init()
    
    func sendMessage(chatRoomId: Int, content: String) {
        chatNetworkManager.messageSend(chatRoomId: chatRoomId, content: content)
    }
    
    func getAllMessages(chatRoomId: Int) async throws-> [ChatMessageResponseDTO] {
        return try await chatNetworkManager.getMessages(chatRoomId: chatRoomId)
    }
    
    
}
