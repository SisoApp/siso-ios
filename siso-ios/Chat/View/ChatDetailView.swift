//
//  ChatDetailView.swift
//  chat
//
//  Created by 김용해 on 8/20/25.
//

import SwiftUI
import designSystem
import model

// MARK: - 스크롤 위치 감지를 위한 PreferenceKey (View 외부에 정의)
private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension ChatMainView {
    
    public struct ChatDetailView: View {
        // MARK: - Properties
        @Environment(\.dismiss) private var dismiss
        @StateObject private var chatDetailViewModel: ChatDetailViewModel = .init()

        // View State
        @State private var isShowingOptions = false
        @State private var message: String = ""
        @State private var isInitialLoad = true // 첫 로드 시 스크롤 관리를 위한 상태
        @FocusState private var isFocused: Bool
        
        // From Parent View
        public let chat: ChatRoomResponseDTO
        
        // For ScrollView
        private let bottomID = "bottomID"
        
        public init(chat: ChatRoomResponseDTO) {
            self.chat = chat
        }
        
        // MARK: - Body
        public var body: some View {
            VStack(spacing: 16) { // 메시지 간 간격 추가
                // dateLine(date: .now) // 날짜 라인은 메시지 데이터 기반으로 표시하는 것이 좋음 (추후 구현)
                messageListView()
                // permitLine // 이 라인도 특정 조건에 따라 표시되도록 하는 것이 좋음 (추후 구현)
                bottomChatTextForm()
            }
            .background(Color.white) // 채팅방 배경색 지정
            .toolbar(.hidden, for: .tabBar)
            .padding(.top, 1) // NavigationBar와 컨텐츠 간 간격
            .navigationBarBackButtonHidden()
            .toolbar { navigationToolbar } // Toolbar 분리
            .confirmationDialog("옵션", isPresented: $isShowingOptions, titleVisibility: .hidden) {
                optionsDialog
            }
            .onAppear {
                print("DetailView Appeared")
                chatDetailViewModel.currentChatRoomId = chat.id
                chatDetailViewModel.loadInitialMessages()
            }
            .onDisappear {
                print("DetailView Disappeared")
                chatDetailViewModel.cleanupOnDisappear()
            }
        }
        
        // MARK: - Subviews
        
        @ViewBuilder
        private func messageListView() -> some View {
            ScrollViewReader { proxy in
                ScrollView {
                    // 스크롤 최상단 감지를 위한 GeometryReader
                    GeometryReader { geometry in
                        Color.clear.preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: geometry.frame(in: .named("scroll")).minY
                        )
                    }
                    .frame(height: 0)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        // 이전 메시지 로딩 인디케이터
                        if chatDetailViewModel.isLoadingMore {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .padding()
                        }
                        
                        ForEach(chatDetailViewModel.messages) { message in
                            messageRowView(for: message)
                                .id(message.id) // 각 메시지에 고유 ID 부여
                        }
                        
                        // 스크롤 맨 아래 위치를 잡기 위한 Spacer
                        Spacer().frame(height: 1).id(bottomID)
                    }
                    .padding(.horizontal)
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    // 사용자가 스크롤을 위로 당겼을 때 (값이 양수가 됨)
                    if value > 0 {
                        guard let roomId = chatDetailViewModel.currentChatRoomId else { return }
                        Task{
                            do {
                                let newMsg = try await chatDetailViewModel.getPrevMessages(chatRoomId: roomId)
                                chatDetailViewModel.messages.insert(contentsOf: newMsg, at: 0)

                            } catch {
                                print("Can not Load Prev Messages: \(error)")
                            }
                        }
                    }
                }
                .onTapGesture {
                    isFocused = false
                }
                .onChange(of: chatDetailViewModel.messages) { oldValue, newValue in
                    handleScrollOnMessageChange(proxy: proxy, oldValue: oldValue, newValue: newValue)
                }
            }
        }
        
        private func bottomChatTextForm() -> some View {
            HStack(spacing: 12) {
                TextField("메세지 보내기", text: $message)
                    .focused($isFocused)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(Color.Siso.Gray._20)
                    .clipShape(Capsule())
                
                Button {
                    chatDetailViewModel.sendMessage(chatRoomId: chat.id, content: message)
                    message = ""
                } label: {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 42, height: 42)
                        .background(Color.Siso.Primary.main)
                        .clipShape(Circle())
                }
                .disabled(message.isEmpty) // 메시지가 비어있으면 버튼 비활성화
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        
        @ViewBuilder
        private func messageRowView(for message: ChatMessageResponseDTO) -> some View {
            switch chatDetailViewModel.getMessageType(message) {
            case .sender:
                senderMessageView(message)
            case .receiver:
                receiverMessageView(message)
            }
        }

        private func senderMessageView(_ message: ChatMessageResponseDTO) -> some View {
            HStack(alignment: .bottom, spacing: 8) {
                Spacer()
                Text(message.createdAt.getMessageTime())
                    .font(.system(size: 12)) // 시간 폰트 크기 조정
                    .foregroundStyle(Color.Siso.Gray._50)
                Text(message.content)
                    .font(.system(size: 16)) // 메시지 폰트 크기 조정
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    .background(Color.Siso.Primary._30)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        
        private func receiverMessageView(_ message: ChatMessageResponseDTO) -> some View {
            HStack(alignment: .bottom, spacing: 8) {
                // TODO: 상대방 프로필 이미지 추가
                // Image("profile_placeholder").resizable().frame(width: 32, height: 32).clipShape(Circle())
                
                Text(message.content)
                    .font(.system(size: 16))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    .background(Color.Siso.Gray._20)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text(message.createdAt.getMessageTime())
                    .font(.system(size: 12))
                    .foregroundStyle(Color.Siso.Gray._50)
                Spacer()
            }
        }
        
        // MARK: - Toolbar & Dialog Content
        
        @ToolbarContentBuilder
        private var navigationToolbar: some ToolbarContent {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                    Text(chat.otherUserNickName)
                        .font(.system(size: 20, weight: .bold))
                        .lineLimit(1)
                }
                .onTapGesture { dismiss() }
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 8) {
                    Image(systemName: "phone.fill")
                        .foregroundStyle(Color.Siso.Green._60)
                        .font(.title3)
                        .frame(width: 40, height: 40)
                        .onTapGesture { print("전화걸기") }
                    Image("ellipsis")
                        .resizable().scaledToFit().frame(width: 24, height: 24)
                        .frame(width: 40, height: 40)
                        .onTapGesture { isShowingOptions = true }
                }
            }
        }
        
        @ViewBuilder
        private var optionsDialog: some View {
            Button("채팅 나가기", role: .destructive) { print("채팅 나가기 선택") }
            Button("신고하기") { print("신고하기 선택") }
            Button("취소", role: .cancel) { }
        }
        
        // MARK: - Functions
        
        private func handleScrollOnMessageChange(proxy: ScrollViewProxy, oldValue: [ChatMessageResponseDTO], newValue: [ChatMessageResponseDTO]) {
            if isInitialLoad {
                scrollToBottom(proxy: proxy, animated: false)
                isInitialLoad = false
            } else if newValue.count > oldValue.count && oldValue.first?.id != newValue.first?.id {
                // 이전 메시지가 로드된 경우: 스크롤 위치 유지를 위해 아무것도 안함
            } else {
                // 새 메시지가 도착했거나 보낸 경우: 맨 아래로 스크롤
                scrollToBottom(proxy: proxy, animated: true)
            }
        }
        
        private func scrollToBottom(proxy: ScrollViewProxy, animated: Bool = true) {
            if animated {
                withAnimation { proxy.scrollTo(bottomID, anchor: .bottom) }
            } else {
                proxy.scrollTo(bottomID, anchor: .bottom)
            }
        }
    }
}
