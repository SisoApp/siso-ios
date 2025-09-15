// CallViewModel.swift

import SwiftUI
import Combine
import model
import Foundation
import network

@MainActor // UI와 직접 상호작용하므로 클래스 전체를 MainActor로 지정합니다.
public class CallViewModel: ObservableObject, Identifiable {
    
    public let id = UUID() // SwiftUI 리스트나 시트 등에서 식별자로 사용하기 위해 추가
    
    // MARK: - Published Properties
    
    @Published public var remainTime: String = "00:00"
    @Published public var remainingSeconds: TimeInterval
    @Published public var isMuteMode: Bool = false {
        didSet { agoraManager.muteLocalAudio(isMuteMode) } // 상태가 바뀌면 즉시 Agora에 적용
    }
    @Published public var isSpeakerMode: Bool = false {
        didSet { agoraManager.enableSpeakerphone(isSpeakerMode) } // 상태가 바뀌면 즉시 Agora에 적용
    }
    
    // MARK: - Properties
    
    public let opponentProfile: CallProfileDto
    
    private let callmanager = CallManager.shared
    private let agoraManager = AgoraManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    private var timerSubscription: AnyCancellable?
    private let initialCallDuration: TimeInterval = 480.0 // 초기 통화 시간: 8분 (480초)
    
    // MARK: - Initializer
    
    public init(opponentProfile: CallProfileDto) {
        self.opponentProfile = opponentProfile
        self.remainingSeconds = initialCallDuration
        self.remainTime = timeString(from: initialCallDuration)
        
        bindAgoraManager()
        
        // remainingSeconds의 변화를 감지하여 remainTime을 업데이트하는
        // '영구적인' 파이프라인을 init에서 '단 한 번만' 설정합니다.
        $remainingSeconds
            .map { [weak self] seconds in
                // 약한 참조로 순환 참조를 방지하는 것이 더 안전합니다.
                self?.timeString(from: seconds) ?? "00:00"
            }
            .assign(to: \.remainTime, on: self)
            .store(in: &cancellables) // 구독을 cancellables에 저장하여 생명주기를 관리합니다.
    }
    
    public init (opponentProfile: MatchingProfile) {
        self.opponentProfile = CallProfileDto.init(from: opponentProfile)
        self.remainingSeconds = initialCallDuration
        self.remainTime = timeString(from: initialCallDuration)
        
        bindAgoraManager()
        
        // remainingSeconds의 변화를 감지하여 remainTime을 업데이트하는
        // '영구적인' 파이프라인을 init에서 '단 한 번만' 설정합니다.
        $remainingSeconds
            .map { [weak self] seconds in
                // 약한 참조로 순환 참조를 방지하는 것이 더 안전합니다.
                self?.timeString(from: seconds) ?? "00:00"
            }
            .assign(to: \.remainTime, on: self)
            .store(in: &cancellables) // 구독을 cancellables에 저장하여 생명주기를 관리합니다.
    }
    
    deinit {
        print("CallViewModel deinitialized")
        // deinit에서 stopTimer()를 호출하지 않습니다.
        // self.cancellables에 저장된 모든 구독(timerSubscription 포함)은
        // ViewModel 인스턴스가 메모리에서 해제될 때 자동으로 cancel()되어 정리됩니다.
    }
    
    // MARK: - Private Methods
    
    private func bindAgoraManager() {
        agoraManager.userDidJoinPublisher
            .receive(on: DispatchQueue.main)
            .first() // 상대방이 입장하는 이벤트를 단 한 번만 수신하여 타이머 중복 시작 방지
            .sink { [weak self] uid in
                print("Opponent (uid: \(uid)) joined. Starting call timer.")
                self?.startTimer()
            }
            .store(in: &cancellables)
    }
    
    private func startTimer() {
        // 이미 타이머가 실행 중이면 중복 실행 방지
        guard timerSubscription == nil else { return }
        
        // Combine의 Timer.publish를 사용하여 1초마다 이벤트를 방출하는 타이머를 생성
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                } else {
                    // 시간이 다 되면 통화를 종료하고 타이머를 멈춥니다.
                    Task{
                        print("Time is up! Ending the call.")
                        self.stopTimer() // 타이머를 먼저 멈추고
                        await self.endCall()   // 통화 종료 로직 호출
                    }
                }
            }
        // 타이머 구독도 cancellables에 저장하여 생명주기를 관리합니다.
        timerSubscription?.store(in: &cancellables)
    }
    
    private func stopTimer() {
        timerSubscription?.cancel()
        timerSubscription = nil
    }
    
    private func timeString(from totalSeconds: TimeInterval) -> String {
        let secondsInt = Int(totalSeconds)
        let minutes = secondsInt / 60
        let seconds = secondsInt % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Public Methods for UI Actions
    
    /// UI에서 통화 종료 버튼을 눌렀을 때 호출됩니다.
    public func endCall() async {
        print("endcall")
        stopTimer()
        
        // 먼저 앱 상태를 바꿔서 UI 전환을 시작시킨다.
        await callmanager.endCall(wasConnected: true)
        
        // 그 다음 백그라운드 작업 성격인 채널 퇴장을 처리한다.
        agoraManager.leaveChannel()
        
    }
}
