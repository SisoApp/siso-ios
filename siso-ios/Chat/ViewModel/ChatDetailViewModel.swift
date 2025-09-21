//
//  ChatDetailViewModel.swift
//  chat
//
//  Created by jdios on 9/16/25.
//

import Foundation
import Combine
import network
import model

enum MessageType {
    case sender
    case receiver
}

class ChatDetailViewModel: ObservableObject {
    @Published var messages: [ChatMessageResponseDTO] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var isConnected: Bool = true
    
    let chatNetworkManager: ChatNetwork  = .shared
    
    private var cancellables: Set<AnyCancellable> = .init()
    var currentChatRoomId: Int?
    
    // 메시지 전송
    private let sendMessageSubject: PassthroughSubject<(chatRoomId: Int, content: String), Never> = .init()
    // 능동적 메시지 갱신 (발신)
    private let manualRefreshSubject: PassthroughSubject<Int, Never> = .init()
    // 수동적 메시지 갱신 (수신)
    private let incomingMessageSubject: PassthroughSubject<ChatMessageResponseDTO, Never> = .init()
    
    private var myUserId: Int?
    
    init() {
        setupMyUserId()
        setupCombineBindings()
    }
    
    deinit {
           print("ChatDetailViewModel deinitialized")
           // ViewModel이 메모리에서 해제될 때 모든 구독 취소
           cancellables.forEach { $0.cancel() }
       }
    
    func setupMyUserId() {
        guard let myUserIdString = KeyChainManager.shared.get(for: "myUserId"),
              let currentUserId = Int(myUserIdString) else {
            return
        }
        myUserId = currentUserId
    }
    
    func setupCombineBindings() {
        sendMessageSubject // 메시지 전송
            .handleEvents(receiveOutput: { [weak self] _ in // send 받으면 실행
                self?.isLoading = true
                self?.error = nil
            })
            .flatMap { [weak self] (roomId, content) -> AnyPublisher<Void, Error> in
                return Future { promise in // 비동기 작업으로 전환
                    self?.chatNetworkManager.messageSend(chatRoomId: roomId, content: content)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        promise(.success(()))
                    }
                }
                .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false // 로딩 종료
                if case .failure(let error) = completion {
                    self?.error = error // 실패시 에러 저장
                }
            } receiveValue: { [weak self] _ in
                guard let self = self, let roomId = currentChatRoomId else { return }
                self.manualRefreshSubject.send(roomId) // 메시지 전송이 완료되면 data 갱신
            }
            .store(in: &cancellables)
        
        manualRefreshSubject // 메시지 갱신
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // 과도한 요청 방지
            .flatMap { [weak self] roomId -> AnyPublisher<[ChatMessageResponseDTO], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                
                return Future { promise in
                    Task {
                        do {
                            let messages = try await self.getAllMessages(chatRoomId: roomId)
                            promise(.success(messages))
                        } catch {
                            promise(.success(self.messages)) // 실패시 기존 메시지 유지
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.messages, on: self)
            .store(in: &cancellables)
        
        incomingMessageSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self = self, let roomId = self.currentChatRoomId, message.chatRoomId == roomId else { return }
                
                if !self.messages.contains(where: { $0.id == message.id }) {
                    print("✅ Socket 수신 완료!")
                    self.messages.append(message)
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: NSNotification.Name("newMessage"))
            .compactMap { $0.object as? ChatMessageResponseDTO }
            .sink { [weak self] message in
                self?.incomingMessageSubject.send(message)
            }
            .store(in: &cancellables)
    }
    
    func loadInitialMessages() {
        guard let roomId = currentChatRoomId else { return }
        chatNetworkManager.subscribeToRoom(roomId: roomId) // 채팅방 구독
        manualRefreshSubject.send(roomId) // 기존 메시지 로드
    }
    // MARK: - NEW CODE: 뷰가 사라질 때 호출될 클린업 함수
       /// 뷰가 사라질 때 소켓 연결을 정리합니다.
       func cleanupOnDisappear() {
           guard let roomId = currentChatRoomId else { return }
           print("Cleaning up chat for room \(roomId)")
           chatNetworkManager.unsubscribeFromRoom(roomId: roomId)
           chatNetworkManager.disconnectStomp()
       }
    
    func sendMessage(chatRoomId: Int, content: String) {
        if !content.isEmpty {
            sendMessageSubject.send((chatRoomId: chatRoomId, content: content))
        }
        
    }
    
    func getAllMessages(chatRoomId: Int) async throws-> [ChatMessageResponseDTO] {
        return try await chatNetworkManager.getMessages(chatRoomId: chatRoomId)
    }
    
    func getMessageType(_ message: ChatMessageResponseDTO) -> MessageType {
        guard let myUserId = myUserId else {
            return .receiver
        }
        
        return message.senderId == myUserId ? .sender : .receiver
    }
    
    private func getCurrentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.string(from: Date())
    }
}
