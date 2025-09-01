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
        @State private var message: String = ""
        public let chat: RecentChat
        
        public init(chat: RecentChat) {
            self.chat = chat
        }
        
        public var body: some View {
            VStack {
                dateLine(date: .now)
                permitLine
                Spacer()
                bottomChatTextForm()
            }
            .toolbar(.hidden, for: .tabBar)
            .padding()
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
                    .padding(.vertical)
                    .padding(.leading)
                    .background(Color.Siso.Gray._20)
                    .clipShape(.rect(cornerRadius: 999))
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
    }
}

#Preview {
    NavigationStack {
        ChatMainView.ChatDetailView(
            chat: RecentChat(userName: "세종대왕", icon: "person.circle.fill", time: Date().addingTimeInterval(-9000), hasMessages: true)
        )
    }
}

