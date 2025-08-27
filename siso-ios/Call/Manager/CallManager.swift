import Foundation
import Combine
import model // UserProfileServer, IncomingCallInfo 등
// import AgoraRtcKit // AgoraManager가 있으므로 직접 import는 불필요할 수 있음

// MARK: - State & Reason Enums

/// 통화가 종료된 이유를 명시하는 열거형
public enum CallEndReason {
    /// 통화가 정상적으로 완료됨 (상대방이 끊거나 내가 끊음)
    case completed
    /// 상대방이 수신을 거절함
    case rejected
    /// 내가 전화를 받지 못함 (타임아웃)
    case missed
    /// 내가 발신을 취소함
    case cancelled
}

// MARK: - CallManager

public final class CallManager: ObservableObject {
    public static let shared = CallManager()
    
    // MARK: - Published Properties
    
    /// 앱의 현재 통화 상태. private(set)으로 외부에서의 직접적인 수정을 막습니다.
    @Published public private(set) var callState: CallState = .idle
    
    /// 통화 종료 후 팝업과 같은 일회성 이벤트를 전달하기 위한 Publisher
    public let showAfterCallPopupPublisher = PassthroughSubject<UserProfileServer, Never>()
    
    // MARK: - Private Properties
    
    private let agoraManager = AgoraManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    private init() {
        subscribeToAgoraEvents()
    }
    
    // MARK: - Public Actions (API for other parts of the app)
    
    /// [발신자] 상대방에게 전화를 '걸 때' 호출합니다.
    public func startCall(to opponent: UserProfileServer) {
        // 실제 앱에서는 이 부분에서 백엔드 API를 호출하여 채널 ID와 토큰을 받아옵니다.
        // --- Start: Backend API Call Simulation ---
        let channelId = UUID().uuidString // 임시 채널 ID
        let token = "YOUR_AGORA_TEMP_TOKEN" // 임시 토큰
        // --- End: Backend API Call Simulation ---
        
        let info = IncomingCallInfo(channelId: channelId, token: token, opponentProfile: opponent)
        
        // 상태를 '발신 중'으로 변경
        self.callState = .connecting(info: info)
        
        // Agora 채널에 미리 입장하여 상대방을 기다립니다.
        agoraManager.initalizeAndJoinChannel(channelName: info.channelId, token: info.token)
    }

    /// [수신자] AppDelegate에서 푸시를 통해 전화를 '받을 때' 호출합니다.
    public func receiveCall(info: IncomingCallInfo) {
        DispatchQueue.main.async {
            guard case .idle = self.callState else {
                print("⚠️ 이미 다른 통화가 진행 중입니다. 새 전화를 무시합니다.")
                // TODO: 백엔드에 '통화 중(busy)' 상태임을 알리는 API 호출
                return
            }
            self.callState = .receiving(info: info)
        }
    }
    
    /// [수신자] `CalledView`에서 '수락' 버튼을 눌렀을 때 호출합니다.
    public func acceptCall() {
        guard case .receiving(let info) = callState else { return }
        
        agoraManager.initalizeAndJoinChannel(channelName: info.channelId, token: info.token)
        self.callState = .inCall(info: info)
    }
    
    /// 통화를 '거절/종료/취소'할 때 호출합니다.
    public func endCall(reason: CallEndReason) {
        let opponent: UserProfileServer?
        switch callState {
        case .receiving(let info), .connecting(let info), .inCall(let info):
            opponent = info.opponentProfile
        default:
            opponent = nil
        }
        
        agoraManager.leaveChannel()
        self.callState = .idle // 상태를 즉시 유휴 상태로 전환
        
        // 통화 후 팝업이 필요한 경우(정상 종료, 거절)에만 이벤트를 방출합니다.
        if let opponent = opponent, (reason == .completed || reason == .rejected) {
            showAfterCallPopupPublisher.send(opponent)
        }
        
        // TODO: 백엔드에 통화가 종료되었음을 이유와 함께 알리는 API 호출
        // 예: ApiClient.shared.endCall(reason: reason.rawValue)
    }
    
    // MARK: - Private Methods
    
    private func subscribeToAgoraEvents() {
        // ✨ [추가] 상대방이 채널에 입장했을 때 (연결 성공 시)
           agoraManager.userDidJoinPublisher
               .receive(on: DispatchQueue.main)
               .sink { [weak self] _ in
                   // 현재 상태가 '연결 중'일 때만 반응하도록 합니다.
                   guard let self = self, case .connecting(let info) = self.callState else { return }
                   
                   print("🤝 상대방이 통화에 참여했습니다. 상태를 .inCall로 변경합니다.")
                   
                   // 상태를 '통화 중'으로 변경합니다.
                   // 이 상태 변경이 UI를 자동으로 업데이트하는 핵심 트리거가 됩니다.
                   self.callState = .inCall(info: info)
               }
               .store(in: &cancellables)

           // [기존 코드] 상대방이 채널에서 나갔을 때 (통화 중 상대가 끊었을 때)
           agoraManager.userDidLeavePublisher
               .receive(on: DispatchQueue.main)
               .sink { [weak self] _ in
                   if case .inCall = self?.callState {
                       print("📞 상대방이 전화를 종료했습니다.")
                       self?.endCall(reason: .completed)
                   }
               }
               .store(in: &cancellables)
    }
}
