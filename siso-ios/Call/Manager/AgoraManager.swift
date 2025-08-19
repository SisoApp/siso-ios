//sdf

import AgoraRtcKit
import Foundation
import Combine

public final class AgoraManager: NSObject {
    public static let shared = AgoraManager()
    
    // MARK: - Publishers (외부 공개 API)
    
    /// 채널에 성공적으로 입장했을 때 (자신의 uid 방출)
    public let didJoinChannelPublisher = PassthroughSubject<UInt, Never>()
    
    // 채널에서 퇴장했을 때
    public let didLeaveChannelPublisher = PassthroughSubject<Void, Never>()
    
    // Another User Enters the channel (his uid emit)
    public let userDidJoinPublisher = PassthroughSubject<UInt, Never>()
    
    // Another User Leaves the Channel (emit his uid)
    public let userDidLeavePublisher = PassthroughSubject<UInt, Never>()
    
    // When Error Occurred
    public let errorPublisher = PassthroughSubject<AgoraErrorCode, Never>()
    
    // MARK: - Private Properties
    
    private var agoraEngine: AgoraRtcEngineKit?
    private let appId: String = "f10b80b198e94370b54198d4f0dbad7b"
    
    // MARK: -Lifecycle
    
    override init() {
        super.init()
    }
    
    deinit {
        print("AgoraManager deinit")
        leaveChannel()
    }
    
    
    // MARK: - Public Methods
    
    /// Agora 엔진을 초기화하고 음성 통화 채널에 입장합니다.
    /// - Parameters:
    ///   - channelName: 입장할 채널의 이름.
    ///   - token: 인증을 위한 RTC 토큰 (필요시).
    ///
    
    public func initalizeAndJoinChannel(channelName: String, token: String? = nil) {
        let config = AgoraRtcEngineConfig()
        config.appId = appId
        config.audioScenario = .chatRoom
        agoraEngine = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
        
        setupAudio()
        
        let option = AgoraRtcChannelMediaOptions()
        option.clientRoleType = .broadcaster
        option.publishCameraTrack = false
        option.publishMicrophoneTrack = true
        
        let result = agoraEngine?.joinChannel(byToken: token,
                                              channelId: channelName,
                                              uid: 0,
                                              mediaOptions: option)
        
        if result != 0 {
                    print("Failed to join channel with error code: \(String(describing: result))")
            errorPublisher.send(.joinChannelRejected)
                }
    }
    
    /// 채널에서 퇴장하고 엔진을 파괴합니다.
    public func leaveChannel() {
        agoraEngine?.leaveChannel()
        AgoraRtcEngineKit.destroy()
        agoraEngine = nil
    }
    
    // MARK: - Audio Control
    
    /// 자신의 마이크 음소거 여부를 설정합니다.
    /// - Parameter isMuted: true이면 음소거, false이면 음소거 해제.
    public func muteLocalAudio(_ isMuted: Bool) {
        agoraEngine?.muteLocalAudioStream(isMuted)
    }
    
    /// 스피커폰 활성화 여부를 설정합니다.
    /// - Parameter isEnabled: true이면 스피커폰 활성화, false이면 비활성화(일반 통화 리시버).
    
    public func enableSpeakerphone(_ isEnable: Bool) {
        agoraEngine?.setEnableSpeakerphone(isEnable)
    }
    
    // MARK: - Private Helper Methods
    
    private func setupAudio() {
        guard let agoraEngine = agoraEngine else {return}
        // 오디오 모듈 활성화
        agoraEngine.enableAudio()
        // 프로필 설정: 높은 음질, 스테레오, 낮은 지연 시간
        agoraEngine.setAudioProfile(.musicHighQualityStereo)
    }
    
}

extension AgoraManager: AgoraRtcEngineDelegate {
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        didJoinChannelPublisher.send(uid)
    }
    
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        didLeaveChannelPublisher.send(())
    }
    
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        userDidJoinPublisher.send(uid)
    }
    
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        userDidLeavePublisher.send(uid)
    }
    
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        errorPublisher.send(errorCode)
    }
}

