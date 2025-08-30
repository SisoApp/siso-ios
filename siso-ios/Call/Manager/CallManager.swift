// CallManager.swift

import Foundation
import Combine
import model


public enum CallEndReason {
    case completed, rejected, missed, cancelled
}

public final class CallManager: ObservableObject {
    public static let shared = CallManager()
    
    @Published public private(set) var callState: CallState = .idle
    
    // 🔥 1. 외부(Coordinator)에서 구독할 수 있는 Publisher 생성
    public let incomingCallPublisher = PassthroughSubject<FCMDTO, Never>()
    
    public let showAfterCallPopupPublisher = PassthroughSubject<MatchingProfile, Never>()
    
    private let agoraManager = AgoraManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        print("📞 [CallManager] Initialized and subscribing to Agora events.")
        subscribeToAgoraEvents()
    }

    // 🔥 2. AppDelegate에서 호출할 메서드
       public func handleIncomingCall(with payload: FCMDTO) {
           print("📞 CallManager received incoming call payload: \(payload)")
           // Publisher를 통해 이벤트를 방출합니다.
           incomingCallPublisher.send(payload)
       }
    
    #if DEBUG
    public func forceUpdateState(to newState: CallState) {
        print("📞 [CallManager] ⚠️ Forcing state update for TESTING. New state: \(newState)")
        self.callState = newState
    }
    #endif
    
    public func startCall(to opponent: MatchingProfile) {
        let channelId = "test"
        let token = "007eJxTYLjwn7sjd6eW1rbHqxLcxffzPDv8/cibPPXGxdMNW8sWvZqpwJBoaWiSmpJoYW6cbGCSZmCZaG6UmmqelGKcampkZGxg8LF3fUZDICPDWRUBVkYGCATxWRhKUotLGBgA95Mhlw=="
        let info = FCMDTO(channelId: channelId, token: token, opponentProfile: opponent)
        
        print("📞 [CallManager] ➡️ startCall to '\(opponent.nickname)'. Changing state to .connecting")
        self.callState = .connecting(info: info)
        
        agoraManager.initalizeAndJoinChannel(channelName: info.channelId, token: info.token)
    }

    public func receiveCall(info: FCMDTO) {
        print("📞 [CallManager] ➡️ receiveCall from '\(info.opponentProfile.nickname)'. Current state: \(self.callState)")
        DispatchQueue.main.async {
            guard case .idle = self.callState else {
                print("📞 [CallManager] 🔴 Call ignored because another call is already in progress.")
                return
            }
            print("📞 [CallManager] ✅ Call accepted. Changing state to .receiving.")
            self.callState = .receiving(info: info)
        }
    }
    
    public func acceptCall() {
        guard case .receiving(let info) = callState else {
            print("📞 [CallManager] 🔴 acceptCall failed. Not in .receiving state.")
            return
        }
        
        print("📞 [CallManager] ➡️ acceptCall. Joining Agora channel.")
        agoraManager.initalizeAndJoinChannel(channelName: info.channelId, token: info.token)
        // 상태 변경은 subscribeToAgoraEvents의 didJoinChannelPublisher에서 처리하는 것이 더 정확하지만,
        // UI의 즉각적인 반응을 위해 여기서 먼저 변경합니다.
        // self.callState = .inCall(info: info)
    }
    
    public func endCall(reason: CallEndReason) {
        let opponent: MatchingProfile?
        let currentState = callState // 로그를 위해 현재 상태 저장
        
        switch callState {
        case .receiving(let info), .connecting(let info), .inCall(let info):
            opponent = info.opponentProfile
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
