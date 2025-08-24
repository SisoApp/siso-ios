// InCallViewModel.swift

import SwiftUI
import Combine
import model

// 이제 싱글톤이 아닌 일반 ObservableObject
public class InCallViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isMuteMode: Bool = false
    @Published var isSpeakerMode: Bool = false
    @Published var callDuration: TimeInterval = 0
    @Published var connectedUserIDs: Set<UInt> = []
    
    // MARK: - Properties
    let opponentProfile: UserProfileServer
    private let agoraManager = AgoraManager.shared
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?

    // View가 생성될 때 상대방 정보를 주입받음
    init(opponentProfile: UserProfileServer) {
        self.opponentProfile = opponentProfile
        bindAgoraManager()
    }
    
    deinit {
        print("InCallViewModel deinit")
        timer?.invalidate()
    }

    private func bindAgoraManager() {
        agoraManager.userDidJoinPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uid in
                self?.connectedUserIDs.insert(uid)
                // 상대방이 들어오면 타이머 시작
                if self?.timer == nil {
                    self?.startTimer()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods (UI Actions)
    
    func toggleMute() {
        isMuteMode.toggle()
        agoraManager.muteLocalAudio(isMuteMode)
    }
    
    func toggleSpeaker() {
        isSpeakerMode.toggle()
        agoraManager.enableSpeakerphone(isSpeakerMode)
    }
    
    // MARK: - Private Methods
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.callDuration += 1
        }
    }
}
