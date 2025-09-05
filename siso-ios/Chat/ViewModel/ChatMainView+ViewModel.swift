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

extension ChatMainView {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var selectedList: ContactType = .callList
        @Published var callHistory: [Contact] = []
        @Published var recentChats: [ChatRoomResponseDTO] = []
        let networkManager: ChatNetwork = .init()
        
        func fetchAllChat() async {
            do {
                let chats = try await networkManager.readAll()
                recentChats = chats
                let calls = try await NetworkManager.shared.getCallHistoryWithReceiverId()
                let calls2 = try await NetworkManager.shared.getCallHistoryWithCallerId()
                print("현재 채팅 리스트 : \(recentChats)")
                print("call : \(calls + calls2)")
            } catch {
                print("chats fetch error: \(error)")
            }
        }
    }
}
