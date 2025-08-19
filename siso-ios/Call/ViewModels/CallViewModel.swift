//
//  CallManager.swift
//  siso-ios
//
//  Created by jdios on 8/16/25.
//


import SwiftUI
import Combine
import AgoraRtcKit
import call


public class CallViewModel: ObservableObject {
    
    // MARK: - Properties
    public static let shared = CallViewModel()
    
    public weak var delegate: MatchingCoordinatorDelegate?
    
    public init( isMuteMode: Bool = false, isSpeakerMode: Bool = false) {
        self.isMuteMode = isMuteMode
        self.isSpeakerMode = isSpeakerMode
    }
    
    private let agoraManager = AgoraManager.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    
    
    // MARK: - Published Properties
    
    @Published public var connectedUserIDs: Set<UInt> = []
    // 전화 시간
    @Published public var callDuration: TimeInterval = 0
    
    @Published var isMuteMode = false
    {
        willSet {
            if newValue == true {
                muteOn()
            } else {
                muteOff()
            }
        }
    }
    @Published var isSpeakerMode = false
    {
        willSet {
            if newValue == true {
                speakerModeOn()
            } else {
                speakerModeOff()
            }
        }
    }
    @Published public var isCallConnected: Bool = false
    
    // 3. init에서 AgoraManager의 Publisher를 구독
    private init() {
        bindAgoraManager()
    }
    private func bindAgoraManager() {
        agoraManager.didJoinChannelPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isCallConnected = true
            }
            .store(in: &cancellables)
        
        agoraManager.userDidJoinPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uid in
                self?.connectedUserIDs.insert(uid)
            }
            .store(in: &cancellables)
        
        agoraManager.userDidLeavePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uid in
                self?.connectedUserIDs.remove(uid)
                // 만약 1:1 통화라면, 상대방이 나가면 통화 종료
                if self?.connectedUserIDs.isEmpty == true {
                    self?.quitCall()
                }
            }
            .store(in: &cancellables)
        
        // 채널에서 나갔을 때 상태 초기화
        agoraManager.didLeaveChannelPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.resetStates()
            }
            .store(in: &cancellables)
    }
    
    private func resetStates() {
        isCallConnected = false
        isMuteMode = false
        isSpeakerMode = false
        connectedUserIDs.removeAll()
    }
    
    func startCall(channelName: String, token: String? = nil) {
        // 전화 시작
        print("CallManager: Starting call for channel \(channelName)")
        agoraManager.initalizeAndJoinChannel(channelName: channelName, token: token)
        delegate?.pushCallingView()
    }
    
    func quitCall() {
        print("CallManager: Ending call")
        agoraManager.leaveChannel()
        
        delegate?.popToRoot()
        
        delegate?.pushCallInteruptPopup()
    }
    
    func speakerModeOn() {
        print("speakerPhoneMode")
        agoraManager.enableSpeakerphone(true)
    }
    
    func speakerModeOff() {
        print("speakerPhoneModeOff")
        agoraManager.enableSpeakerphone(false)
    }
    
    func muteOn() {
        print("MuteModeOn")
        agoraManager.muteLocalAudio(true)
    }
    
    func muteOff() {
        print("MuteModeOff")
        agoraManager.muteLocalAudio(false)
    }
    
    
}
