//
//  ChatDetailView.swift
//  chat
//
//  Created by 김용해 on 8/20/25.
//

import SwiftUI
import designSystem
import model

extension ChatMainView {
    
    public struct ChatDetailView: View {
        @Environment(\.dismiss) private var dismiss
        @State private var isShowingOptions = false
        @State private var message: String = ""
        @FocusState private var isFocused: Bool
        
        @StateObject private var chatDetailViewModel: ChatDetailViewModel = .init()
        public let chat: ChatRoomResponseDTO
        
        public init(chat: ChatRoomResponseDTO) {
            self.chat = chat
        }
        
        public var body: some View {
            VStack {
                dateLine(date: .now)
                messageListView()
                permitLine
                Spacer()
                bottomChatTextForm()
            }
            .toolbar(.hidden, for: .tabBar)
            .padding(.vertical)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text(chat.otherUserNickName)
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
            .onAppear {
                chatDetailViewModel.currentChatRoomId = chat.id
                chatDetailViewModel.loadInitialMessages()
            }
        }
        
        private func messageListView() -> some View {
            ScrollView {
                VStack {
                    ForEach(chatDetailViewModel.messages) { message in
                        switch chatDetailViewModel.getMessageType(message) {
                        case .sender:
                            senderMessageView(message)
                        case .receiver:
                            receiverMessageView(message)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .onTapGesture {
                isFocused = false
            }
        }
        
        private func senderMessageView(_ message: ChatMessageResponseDTO) -> some View {
            HStack(alignment: .bottom) {
                Spacer()
                Text(message.createdAt.getMessageTime())
                    .font(.system(size: 15))
                    .foregroundStyle(Color.Siso.Gray._50)
                Text(message.content)
                    .font(.system(size: 20))
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.Siso.Primary._30)
                    )
            }
        }
        
        private func receiverMessageView(_ message: ChatMessageResponseDTO) -> some View {
            HStack(alignment: .bottom) {
                Text(message.content)
                    .font(.system(size: 20))
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.Siso.Gray._20)
                    )
                Text(message.createdAt.getMessageTime())
                    .font(.system(size: 15))
                    .foregroundStyle(Color.Siso.Gray._50)
                Spacer()
            }
        }
        
        // TODO: Date 라인 (날짜가 갱신되면 line을 넣어줍니다)
        private func dateLine(date: Date) -> some View {
            HStack {
                VStack {
                    Divider()
                        .background(Color.Siso.Gray._50)
                }
                Text(Date.formatDate(date: date))
                    .font(.system(size: 16))
                    .foregroundStyle(Color.Siso.Gray._50)
                    .fixedSize(horizontal: true, vertical: false)
                VStack {
                    Divider()
                        .background(Color.Siso.Gray._50)
                }
            }
        }
        
        // TODO: 상대방이 동의하면 대화가 열려요
        private var permitLine: some View {
            HStack {
                VStack {
                    Divider()
                        .background(Color.Siso.Gray._50)
                }
                Text("상대방이 동의하면 대화가 열려요.")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.Siso.Gray._50)
                    .fixedSize(horizontal: true, vertical: false)
                VStack {
                    Divider()
                        .background(Color.Siso.Gray._50)
                }
            }
        }
        
        // TODO: Bottom ChatTextField
        private func bottomChatTextForm() -> some View {
            HStack {
                TextField("메세지 보내기", text: $message)
                    .focused($isFocused)
                    .padding(.vertical)
                    .padding(.leading)
                    .background(Color.Siso.Gray._20)
                    .clipShape(.rect(cornerRadius: 999))
                
                Button {
                    chatDetailViewModel.sendMessage(chatRoomId: chat.id, content: message)
                    message = ""
                } label: {
                    ZStack {
                        Group {
                            Circle()
                                .foregroundStyle(Color.Siso.Primary.main)
                            Image(systemName: "arrow.up")
                        }
                        .frame(maxWidth: 42, maxHeight: 42)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
