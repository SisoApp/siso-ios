// CallManager.swift

import Foundation
import Combine
import model
import network

// CallEndReason은 그대로 사용해도 좋습니다.
public enum CallEndReason {
    case completed, rejected, missed, cancelled
}

public final class CallManager: ObservableObject {
    public static let shared = CallManager()
    
    // ✅ 수정: 새로운 CallState enum 사용
    @Published public private(set) var callState: CallState = .idle
    
    // ✅ 수정: 통화 후 팝업에 더 많은 정보를 전달하기 위해 AfterCallInfo 모델 사용
    public let incomingCallPublisher = PassthroughSubject<CallInfoDto, Never>()
    public let showAfterCallPopupPublisher = PassthroughSubject<AfterCallInfo, Never>() // AfterCallInfo는 아래 정의
    
    private let agoraManager = AgoraManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    var delegate: CallCoordinatorDelegate?
    
    // HIGHLIGHT START: 디버깅 헬퍼 함수 추가
#if DEBUG
    /// [DEBUG ONLY] UI 테스트를 위해 외부에서 CallState를 강제로 변경합니다.
    public func changeStateForDebug(_ newState: CallState) {
        print("🐞 [Debug] Forcing state change to: \(newState)")
        self.callState = newState
    }
#endif
    // HIGHLIGHT END
    private init(delegate: CallCoordinatorDelegate? = nil) {
        print("📞 [CallManager] Initialized and subscribing to Agora events.")
        subscribeToAgoraEvents()
    }
    
    // MARK: - Incoming Call Handling
    
    public func handleIncomingCall(with payload: CallInfoDto) {
        print("📞 CallManager received incoming call payload: \(payload)")
        incomingCallPublisher.send(payload)
    }
    
    // MARK: - Call Actions (Triggered by UI)
    
    // [핵심 1] 발신자: 통화 시작
    public func startCall(to receiver: MatchingProfile) async {
        do {
            let callInfo = try await NetworkManager.shared.requestCall(receiverId: receiver.userId)
            print("📞 서버로부터 받은 통화 정보(callInfo): \(callInfo)")
            if callInfo.token.isEmpty {
                print("🚨🚨🚨 Agora 토큰이 비어있습니다! 🚨🚨🚨")
            }
            await MainActor.run {
                // ✅ 'profile'과 'info'를 모두 담아서 .connecting 상태로 변경!
                self.callState = .connecting(profile: receiver, info: callInfo)
            }
            
            agoraManager.initalizeAndJoinChannel(channelName: callInfo.channelName, token: callInfo.token)
        } catch {
            await MainActor.run { self.callState = .idle }
        }
    }
    
    // [핵심 2] 수신자: 통화 수락
    public func acceptCall() async {
        guard case .receiving(let info) = callState else { return }
        do {
            let response = try await NetworkManager.shared.acceptCall(callInfo: info)
            // 서버 응답에서 발신자(상대)의 프로필 정보를 얻음
            let opponentProfile = MatchingProfile(from: response.callerProfile, userId: response.callerId)
            
            await MainActor.run {
                // ✅ 'profile'과 'info'를 모두 담아서 .inCall 상태로 변경!
                self.callState = .inCall(profile: opponentProfile, info: info)
            }
            agoraManager.initalizeAndJoinChannel(channelName: response.channelName, token: response.token)
        } catch {
            await MainActor.run { self.callState = .idle }
        }
    }
    
    
    // 수신자 전용 (Push 알림 또는 소켓 이벤트 수신 시)
    public func receiveCall(info: CallInfoDto) {
        print("📞 [CallManager] ➡️ receiveCall from callerId: \(info.callerId).")
        DispatchQueue.main.async {
            guard self.callState == .idle else {
                print("📞 [CallManager] 🔴 Call ignored because another call is already in progress.")
                // TODO: 상대방에게 "통화 중"임을 알리는 API 호출 (e.g., busyCall)
                return
            }
            print("📞 [CallManager] ✅ Changing state to .receiving.")
            self.callState = .receiving(info: info)
        }
    }
    
    
    
    // 수신자 전용 (사용자가 '거절' 버튼 클릭)
    public func denyCall() async {
        guard case .receiving(let info) = callState else {
            print("📞 [CallManager] 🔴 denyCall failed. Not in .receiving state.")
            return
        }
        
        // UI 즉시 반응을 위해 상태부터 변경
        await MainActor.run {
            self.callState = .idle
        }
        
        // 서버에 거절 사실 알림 (실패해도 UI에 영향 없음)
        Task.detached {
            do {
                _ = try await NetworkManager.shared.denyCall(callInfo: info)
                print("📞 [CallManager] ✅ Call denied on server.")
            } catch {
                print("🔴 [CallManager] denyCall on server failed: \(error.localizedDescription)")
            }
        }
    }
    
    // 발신/수신 공통 (사용자가 '종료' 또는 '취소' 버튼 클릭)
    // CallManager.swift
    
    // [핵심 3] 공통: 통화 종료
    // wasConnected: 실제로 통화가 연결되었었는지 여부
    public func endCall(wasConnected: Bool) async {
        let currentState = self.callState
        agoraManager.leaveChannel()
        
        if wasConnected {
            if case .inCall(let profile, let info) = currentState {
                // ✅ 연결된 통화가 끝났으므로 -> 평가 상태(.assessment)로 전환
                await MainActor.run {
                    self.callState = .assessment(profile: profile, info: info)
                }
            }
        } else {
            // ✅ 연결되지 않은 통화(취소/거절)는 -> 바로 종료(.idle)
            await MainActor.run {
                self.callState = .idle
            }
        }
        
        // ✅ 서버에는 '통화 종료' 사실만 알림 (continueRelationship 없이)
        //    별도의 '종료' API가 없다면, 이 단계에서는 API 호출을 생략하고
        //    decideRelationship에서만 호출하는 방법도 있음.
        //    여기서는 '결정 보류'의 의미로 false를 보내는 것으로 가정.
        let infoToLog: CallInfoDto?
        switch currentState {
        case .inCall(_, let info), .connecting(_, let info), .receiving(let info):
            infoToLog = info
        default:
            infoToLog = nil
        }
        
        if let info = infoToLog {
            Task.detached {
                // continueRelationship은 아직 결정되지 않았으므로 false로 전송
                _ = try? await NetworkManager.shared.endCall(callInfo: info, continueRelationship: false)
                print("📞 [CallManager] ✅ Call ended on server (pre-assessment).")
            }
        }
    }
    // [핵심 4] 평가 완료 후 최종 종료
    // assessment 상태에서 호출
    @MainActor
    public func decideRelationship(continueRelationship: Bool) async {
        guard case .assessment(_, let info) = callState else {
            print("📞 [CallManager] decideRelationship ignored. Not in assessment state.")
            return
        }
        
        
        
        await MainActor.run {
            self.callState = .idle
        }
        if continueRelationship {
            delegate?.popToRootAndGoToChat()
        
        }
        // ✅ 서버에 최종 결정 사항(continueRelationship)을 전송
        Task.detached {
            do {
                _ = try await NetworkManager.shared.endCall(callInfo: info, continueRelationship: continueRelationship)
                print("📞 [CallManager] ✅ Relationship decision sent to server.")
            } catch {
                print("🔴 [CallManager] Sending relationship decision failed: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Agora Event Subscriptions
    
    // [핵심 5] Agora 이벤트 구독
    private func subscribeToAgoraEvents() {
        agoraManager.userDidJoinPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                // ✅ .connecting 상태일 때 상대가 들어오면, .inCall로 상태 변경
                guard let self = self, case .connecting(let profile, let info) = self.callState else { return }
                self.callState = .inCall(profile: profile, info: info)
            }
            .store(in: &cancellables)
        
        agoraManager.userDidLeavePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                // ✅ 통화 중(.inCall)에 상대가 나가면 -> 연결되었던 통화 종료로 처리
                if case .inCall = self.callState {
                    Task { @MainActor in
                        await self.endCall(wasConnected: true) }
                }
            }
            .store(in: &cancellables)
    }
}


// MARK: - Helper Models
// Coordinator로 통화 후 정보를 전달하기 위한 모델
public struct AfterCallInfo {
    public let profile: MatchingProfile
    public let callInfo: CallInfoDto
}
