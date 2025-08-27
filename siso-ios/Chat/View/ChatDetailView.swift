//
//  ChatDetailView.swift
//  chat
//
//  Created by 김용해 on 8/20/25.
//

import SwiftUI
import designSystem

extension ChatMainView {
    
    public struct ChatDetailView: View {
        @Environment(\.dismiss) private var dismiss
        @State private var isShowingOptions = false
        public let chat: RecentChat
        
        public init(chat: RecentChat) {
            self.chat = chat
        }
        
        public var body: some View {
            VStack {
                
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text(chat.userName)
                            .font(.system(size: 24, weight: .bold))
                            .lineLimit(1)
                    }
                    .onTapGesture {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundStyle(Color.Siso.Green._60)
                            .font(.title2)
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                print("전화걸기")
                            }
                        Image("ellipsis")
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                isShowingOptions = true
                            }
                    }
                }
            }
            .confirmationDialog("옵션", isPresented: $isShowingOptions, titleVisibility: .hidden) {
                Button("채팅 나가기", role: .destructive) {
                    // 채팅 나가기 액션
                    print("채팅 나가기 선택")
                }
                
                Button("신고하기") {
                    // 신고하기 액션
                    print("신고하기 선택")
                }
                
                Button("취소", role: .cancel) { }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatMainView.ChatDetailView(
            chat: ChatMainView.RecentChat(userName: "세종대왕", icon: "person.circle.fill", time: Date().addingTimeInterval(-9000), hasMessages: true)
        )
    }
}

