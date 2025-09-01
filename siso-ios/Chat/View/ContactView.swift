//
//  ContactView.swift
//  chat
//
//  Created by 김용해 on 8/20/25.
//

import SwiftUI
import designSystem

extension ChatMainView {
    struct ContactView: View {
        let contact: Contact?
        let chat: RecentChat?
        let type: ContactType
        let delegate: ChatCoordinatorDelegate?
        init(contact: Contact? = nil, chat: RecentChat? = nil, type: ContactType, delegate: ChatCoordinatorDelegate?) {
            self.contact = contact
            self.chat = chat
            self.type = type
            self.delegate = delegate
        }
        
        // TODO: 각 연락처 내부 정보 뷰
        var body: some View {
            HStack {
                switch type {
                    case .callList:
                        if let contact = contact {
                            Image(systemName: contact.icon)
                                .resizable()
                                .frame(width: 56, height: 56)
                            callView(username: contact.userName, time: Date.formatTime(date: contact.time))
                        }
                    case .recentChat:
                    if let chat = chat {
                            Image(systemName: chat.icon)
                                .resizable()
                                .frame(width: 56, height: 56)
                        recentChatView(username: chat.userName, recentMessage: chat.recentMessage, time: Date.formatTime(date: chat.time), hasMessages: chat.hasMessages)
                        }
                }
                
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.Siso.Gray._30),
                alignment: .bottom
            )
            .contentShape(Rectangle())
            .onTapGesture {
                if type == .recentChat, let chat {
                    delegate?.pushChat(.detail(chat: chat))
                }
            }
        }
        
        private func callView(username: String, time: String) -> some View {
            Group {
                Text(username)
                    .font(.system(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(5.4)
                    .lineLimit(1)
                Text(time)
                    .foregroundStyle(Color.Siso.Gray._50)
                    .font(.system(size: 15, weight: .regular))
                    .tracking(-0.15)
            }
        }
        
        private func recentChatView(username: String, recentMessage: String? = nil, time: String, hasMessages: Bool? = nil) -> some View {
            Group {
                VStack(alignment: .leading) {
                    Text(username)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineSpacing(5.4)
                        .lineLimit(1)
                    Spacer()
                    if let recentMessage = recentMessage {
                        Text(recentMessage)
                            .lineLimit(1)
                            .font(.system(size: 18)).fontWeight(.regular)
                            .foregroundStyle(Color.Siso.Gray._50)
                            .tracking(-0.54)
                    }
                }
                VStack(alignment: .trailing) {
                    Text(time)
                        .foregroundStyle(Color.Siso.Gray._50)
                        .font(.system(size: 15, weight: .regular))
                        .tracking(-0.15)
                    if let hasMessage = hasMessages {
                        if hasMessage {
                            ZStack {
                                Circle()
                                    .frame(maxWidth: 24)
                                    .foregroundStyle(Color.Siso.Primary.main)
                                Text("N")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                        }else {
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}
