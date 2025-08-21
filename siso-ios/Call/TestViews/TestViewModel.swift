// AgoraTestViewModel.swift
import Foundation
import Combine
import AVFoundation // AgoraErrorCode를 사용하기 위해 필요할 수 있습니다.

class AgoraTestViewModel: ObservableObject {
    // MARK: - UI State
    @Published var channelName: String = "test-channel-123"
    @Published var token: String = "" // 필요시 여기에 임시 토큰을 입력하세요.
    
    @Published var isConnected: Bool = false
    @Published var isMuted: Bool = false
    @Published var isSpeakerEnabled: Bool = false
    
    @Published var myUid: UInt? = nil
    @Published var remoteUids: [UInt] = []
    
    @Published var logMessages: [String] = []
    
    // MARK: - Properties
    private let agoraManager = AgoraManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bindAgoraManagerPublishers()
    }
    
    // MARK: - Public Methods (for View)
    
    func joinChannel() {
        log("Joining channel: \(channelName)...")
        let rtcToken = token.isEmpty ? nil : token
        agoraManager.initalizeAndJoinChannel(channelName: channelName, token: rtcToken)
    }
    
    func leaveChannel() {
        log("Leaving channel...")
        agoraManager.leaveChannel()
    }
    
    func toggleMute() {
        isMuted.toggle()
        agoraManager.muteLocalAudio(isMuted)
        log(isMuted ? "Mute ON" : "Mute OFF")
    }
    
    func toggleSpeaker() {
        isSpeakerEnabled.toggle()
        agoraManager.enableSpeakerphone(isSpeakerEnabled)
        log(isSpeakerEnabled ? "Speaker ON" : "Speaker OFF")
    }
    
    // MARK: - Private Methods
    
    private func bindAgoraManagerPublishers() {
        agoraManager.didJoinChannelPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uid in
                self?.isConnected = true
                self?.myUid = uid
                self?.log("✅ Successfully joined channel with UID: \(uid)")
            }
            .store(in: &cancellables)
            
        agoraManager.userDidJoinPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uid in
                self?.remoteUids.append(uid)
                self?.log("👤 User joined: \(uid)")
            }
            .store(in: &cancellables)
            
        agoraManager.userDidLeavePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uid in
                self?.remoteUids.removeAll { $0 == uid }
                self?.log("👋 User left: \(uid)")
            }
            .store(in: &cancellables)
            
        agoraManager.didLeaveChannelPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.resetStates()
                self?.log("🚪 Successfully left channel.")
            }
            .store(in: &cancellables)
            
        agoraManager.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.log("❌ Error occurred: \(error.rawValue)")
            }
            .store(in: &cancellables)
    }
    
    private func resetStates() {
        isConnected = false
        myUid = nil
        remoteUids.removeAll()
        isMuted = false
        isSpeakerEnabled = false
    }
    
    private func log(_ message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        logMessages.insert("[\(timestamp)] \(message)", at: 0)
    }
}
