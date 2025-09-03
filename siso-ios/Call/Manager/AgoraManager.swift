// AgoraManager.swift

import AgoraRtcKit
import Foundation
import Combine

public final class AgoraManager: NSObject {
    public static let shared = AgoraManager()
    
    // ... Publishers (기존 코드와 동일) ...
    public let didJoinChannelPublisher = PassthroughSubject<UInt, Never>()
    public let didLeaveChannelPublisher = PassthroughSubject<Void, Never>()
    public let userDidJoinPublisher = PassthroughSubject<UInt, Never>()
    public let userDidLeavePublisher = PassthroughSubject<UInt, Never>()
    public let errorPublisher = PassthroughSubject<AgoraErrorCode, Never>()
    
    private var agoraEngine: AgoraRtcEngineKit?
    private let appId: String = "a914eda873c04f09a72ee7bd3e522300"
    
    override init() {
        super.init()
        print("🎙️ [AgoraManager] Initialized.")
    }
    
    deinit {
        print("🎙️ [AgoraManager] Deinitialized.")
        leaveChannel()
    }
    
    public func initalizeAndJoinChannel(channelName: String, token: String? = nil) {
        print("🎙️ [AgoraManager] ➡️ Attempting to initialize and join channel: '\(channelName)'")
        // --- [✨ 디버깅 로그 추가 ✨] ---
           // Agora에 접속하기 직전의 모든 중요 정보를 하나의 로그로 출력합니다.
           // 이렇게 하면 어떤 값으로 접속을 시도했는지 명확하게 알 수 있습니다.
           print("""
           🎙️ [AgoraManager] ---> JOINING CHANNEL <---
               - Channel Name: \(channelName)
               - Token Exists: \(token != nil && !(token?.isEmpty ?? true))
               - Token Length: \(token?.count ?? 0)
               - UID: 0 (자동 할당)
           ------------------------------------
           """)
           // --- [로그 추가 끝] ---
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
        
        if result == 0 {
            print("🎙️ [AgoraManager] ✅ joinChannel call succeeded locally. Waiting for delegate callback...")
        } else {
            print("🎙️ [AgoraManager] 🔴 FAILED to join channel with error code: \(String(describing: result))")
            errorPublisher.send(.joinChannelRejected)
        }
    }
    
    public func leaveChannel() {
        print("🎙️ [AgoraManager] ➡️ Leaving channel and destroying engine.")
        agoraEngine?.leaveChannel()
        AgoraRtcEngineKit.destroy()
        agoraEngine = nil
    }
    
    // ... Audio Control (기존 코드와 동일) ...
    public func muteLocalAudio(_ isMuted: Bool) { agoraEngine?.muteLocalAudioStream(isMuted) }
    public func enableSpeakerphone(_ isEnable: Bool) { agoraEngine?.setEnableSpeakerphone(isEnable) }

    private func setupAudio() {
        guard let agoraEngine = agoraEngine else {return}
        agoraEngine.enableAudio()
        agoraEngine.setAudioProfile(.musicHighQualityStereo)
    }
}

extension AgoraManager: AgoraRtcEngineDelegate {
    // 내가 채널에 성공적으로 입장했을 때
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("🎙️ [DELEGATE] ✅ Local user (uid: \(uid)) successfully joined channel '\(channel)'")
        didJoinChannelPublisher.send(uid)
    }
    
    // 내가 채널에서 퇴장했을 때
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        print("🎙️ [DELEGATE] ✅ Local user successfully left the channel.")
        didLeaveChannelPublisher.send(())
    }
    
    // 다른 사용자가 채널에 입장했을 때 (가장 중요!)
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("🎙️ [DELEGATE] 🤝 Remote user (uid: \(uid)) joined the channel. Sending publisher event.")
        userDidJoinPublisher.send(uid)
    }
    
    // 다른 사용자가 채널에서 퇴장했을 때
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("🎙️ [DELEGATE] 👋 Remote user (uid: \(uid)) left the channel. Reason code: \(reason.rawValue)")
        userDidLeavePublisher.send(uid)
    }
    
    // 에러가 발생했을 때
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("🎙️ [DELEGATE] 🔴 An error occurred. Code: \(errorCode.rawValue)")
        errorPublisher.send(errorCode)
    }
}
