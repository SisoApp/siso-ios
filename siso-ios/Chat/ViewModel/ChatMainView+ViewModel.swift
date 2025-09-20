//
//  ChatMainView+ViewModel.swift
//  siso-ios
//
//  Created by 김용해 on 9/3/25.
//

import SwiftUI
import network
import model
import call

public extension ChatMainView {
    @MainActor
    class ChatViewModel: ObservableObject {
        @Published var selectedList: ContactType = .callList
        @Published var callHistory: [Contact] = []
        @Published var recentChats: [ChatRoomResponseDTO] = []
        let networkManager: ChatNetwork = .shared
        
        func fetchAllChat() async {
            do {
                let chats = try await networkManager.readAll()
                recentChats = chats
                let calls = try await NetworkManager.shared.getCallHistoryWithReceiverId()
                let calls2 = try await NetworkManager.shared.getCallHistoryWithCallerId()
                print("현재 채팅 리스트 : \(recentChats)")
            } catch {
                print("chats fetch error: \(error)")
            }
        }
        
        func sendMessage(chatRoomId: Int, content: String) {
            networkManager.messageSend(chatRoomId: chatRoomId, content: content)
        }
        
        
        
    }
}

