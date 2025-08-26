// InCallViewModel.swift

import SwiftUI
import Combine
import model
import Foundation

// 이제 싱글톤이 아닌 일반 ObservableObject
public class CallViewModel: ObservableObject, Identifiable {
    
    public let id = UUID()
    
    // MARK: - Published Properties
    @Published var isMuteMode: Bool = false
    @Published var isSpeakerMode: Bool = false
    
    @Published var isShowingTalkTip: Bool = false
    @Published var isShowingProfile: Bool = false
    @Published var connectedUserIDs: Set<UInt> = []
    @Published var remainTime: String = "00:00"
    
    
    // MARK: - Properties
    var opponentProfile: UserProfileServer
    private let agoraManager = AgoraManager.shared
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    
    // Timer
    var remainingSeconds = 480.0
    private var totalCallDuration: TimeInterval = 480
    private var callDuration: TimeInterval = 0
    

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
            // 타이머가 시작될 때 초기 남은 시간을 설정해줍니다.
            self.remainTime = timeString(from: Int(totalCallDuration))
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }

                // 1. 경과 시간을 1초씩 증가
                self.callDuration += 1
                
                // 2. 남은 시간을 계산
                remainingSeconds = self.totalCallDuration - self.callDuration
                
                if remainingSeconds >= 0 {
                    // 3. 남은 시간이 0 이상이면, 포맷팅하여 Published 프로퍼티 업데이트
                    self.remainTime = self.timeString(from: Int(remainingSeconds))
                } else {
                    // 4. 남은 시간이 0이 되면 타이머를 멈추고 통화 종료 로직 호출
                    self.timer?.invalidate()
                    print("시간 종료! 통화를 종료합니다.")
                    // CallManager를 통해 통화 종료 액션 호출
                    CallManager.shared.endCall(reason: .completed)
                }
            }
        }
    
    private func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        // String(format:)을 사용하여 항상 두 자리 숫자로 표시 (예: 08, 01)
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
