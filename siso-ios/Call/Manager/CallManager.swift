// CallManager.swift

import Foundation
import Combine
import model
import network


public enum CallEndReason {
    case completed, rejected, missed, cancelled
}

public final class CallManager: ObservableObject {
    public static let shared = CallManager()
    
    @Published public private(set) var callState: CallState = .idle
    
    // 🔥 1. 외부(Coordinator)에서 구독할 수 있는 Publisher 생성
    public let incomingCallPublisher = PassthroughSubject<CallInfoDto, Never>()
    
    public let showAfterCallPopupPublisher = PassthroughSubject<CallInfoDto, Never>()
    
    private let agoraManager = AgoraManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        print("📞 [CallManager] Initialized and subscribing to Agora events.")
        subscribeToAgoraEvents()
    }
    
    // 🔥 2. AppDelegate에서 호출할 메서드
    public func handleIncomingCall(with payload: CallInfoDto) {
        print("📞 CallManager received incoming call payload: \(payload)")
        // Publisher를 통해 이벤트를 방출합니다.
        incomingCallPublisher.send(payload)
    }
    
    //    #if DEBUG
    //    public func forceUpdateState(to newState: CallState) {
    //        print("📞 [CallManager] ⚠️ Forcing state update for TESTING. New state: \(newState)")
    //        self.callState = newState
    //    }
    //    #endif
    
    // 발신자 전용
    public func startCall(to receiver: MatchingProfile) async {
        
        do {
            let callInfo = try await NetworkManager.shared.requestCall(receiverId: receiver.userId)
            print("📞 [CallManager] ➡️ startCall to '\(receiver.nickname)'. Changing state to .connecting")
            self.callState = .connecting(info: callInfo)
            
            agoraManager.initalizeAndJoinChannel(channelName: callInfo.channelName, token: callInfo.token)
        } catch {
            print("🔴 [CallManager] startCall failed: \(error.localizedDescription)")
        }
        
    }
    
    // 수신자 전용
    public func receiveCall(info: CallInfoDto) {
        print("📞 [CallManager] ➡️ receiveCall from '\(info.nickname)'. Current state: \(self.callState)")
        DispatchQueue.main.async {
            guard case .idle = self.callState else {
                print("📞 [CallManager] 🔴 Call ignored because another call is already in progress.")
                return
            }
            print("📞 [CallManager] ✅ Call accepted. Changing state to .receiving.")
            self.callState = .receiving(info: info)
        }
    }
    
    // 수신자 전용
    public func acceptCall() async {
        guard case .receiving(let info) = callState else {
            print("📞 [CallManager] 🔴 acceptCall failed. Not in .receiving state.")
            return
        }
        
        print("📞 [CallManager] ➡️ acceptCall. Joining Agora channel.")
        agoraManager.initalizeAndJoinChannel(channelName: info.channelName, token: info.token)
        do {
            let _ = try await NetworkManager.shared.acceptCall(callInfo: info)
            print("📞 [CallManager] ✅ Call accepted on server.")
            agoraManager.initalizeAndJoinChannel(channelName: info.channelName, token: info.token)
        } catch {
            print("🔴 [CallManager] acceptCall failed: \(error.localizedDescription)")
            // TODO: 수락 실패 시 UI 처리 (예: 에러 팝업) 및 상태를 .idle로 되돌리기
            await MainActor.run { self.callState = .idle }
        }
    }
    
    // 수신자 발신자 가리지 않음
    public func endCall(reason: CallEndReason) {
        let opponent: CallInfoDto?
        let currentState = callState // 로그를 위해 현재 상태 저장
        
        switch callState {
        case .receiving(let info), .connecting(let info), .inCall(let info):
            opponent = info
        default:
            opponent = nil
        }
        
        print("📞 [CallManager] ➡️ endCall initiated with reason: \(reason). Current state: \(currentState)")
        
        agoraManager.leaveChannel()
        self.callState = .idle
        print("📞 [CallManager] ✅ State changed to .idle.")
        
        if let opponent = opponent, (reason == .completed || reason == .rejected) {
            print("📞 [CallManager] ✅ Sending showAfterCallPopupPublisher event for '\(opponent.nickname)'.")
            showAfterCallPopupPublisher.send(opponent)
        }
    }
    
    // 양쪽 공통
    private func subscribeToAgoraEvents() {
        // 상대방이 채널에 입장했을 때 (연결 성공 시)
        agoraManager.userDidJoinPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self, case .connecting(let info) = self.callState else { return }
                
                print("📞 [CallManager] 🤝 Received userDidJoin from Agora. Changing state from .connecting to .inCall.")
                self.callState = .inCall(info: info)
            }
            .store(in: &cancellables)
        
        // 상대방이 채널에서 나갔을 때 (통화 중 상대가 끊었을 때)
        agoraManager.userDidLeavePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self, case .inCall = self.callState else { return }
                
                print("📞 [CallManager] 👋 Received userDidLeave from Agora. Ending call.")
                self.endCall(reason: .completed)
            }
            .store(in: &cancellables)
    }
}
