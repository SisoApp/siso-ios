//
//  RecodProfileViewModel.swift
//  profile
//
//  Created by 멘태 on 8/16/25.
//

import AVFoundation
import Combine
import SwiftUI
import network

enum RecordStatus {
    case pending // 녹음 대기
    case recording // 녹음중
    case waiting // 녹음 완료, 사용자 동작 대기 상태
    case playing // 녹음본 재생
}

class RecordProfileViewModel: NSObject, ObservableObject {
    @ObservedObject private var userProfile: UserProfile
    @Published var status: RecordStatus = .pending
    @Published var playTime: Int = 0
    
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    private var fileName: String = "voice.m4a"
    
    private var timer: Timer.TimerPublisher?
    private var cancellables: Set<AnyCancellable> = .init()
    
    var audioFileUrl: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }
    
    var symbolName: String {
        switch status {
        case .pending:
            return "mic"
        case .recording, .playing:
            return "pause"
        case .waiting:
            return "play"
        }
    }
    
    var recordButtonIsActive: Bool {
        return status == .pending
    }
    
    var nextButtonIsActive: Bool {
        return status == .waiting
    }
    
    var restartButtonIsActive: Bool {
        return status == .waiting
    }
    
    init(userProfile: UserProfile) {
        self.userProfile = userProfile
        super.init()
        setupNotificationObservers()
    }
    
    deinit {
        cleanUp()
        NotificationCenter.default.removeObserver(self)
    }
    
    func startTimer(max: Int = 20) {
        removeTimer() // 기존 타이머 정리
        
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
        playTime = 0
        
        timer?.autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.playTime < max {
                    self.playTime += 1
                } else {
                    self.removeTimer()
                }
            }
            .store(in: &cancellables)
    }
    
    func removeTimer() {
        cancellables.removeAll()
        timer = nil
    }
    
    func startRecoding() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
            ]
            
            status = .recording
            recorder = try AVAudioRecorder(url: audioFileUrl, settings: settings)
            recorder?.record()
            startTimer()
        } catch {
            print("Failed to start recording:", error)
        }
    }
    
    func stopRecording() {
        removeTimer()
        recorder?.stop()
        recorder = nil
        status = .waiting
        userProfile.voice = true
        
        try? AVAudioSession.sharedInstance().setActive(false) // AVAudioSession 비활성화
    }
    
    func startPlaying() {
        do {
            try player = AVAudioPlayer(contentsOf: audioFileUrl)
            startTimer()
            player?.delegate = self
            player?.play()
            status = .playing
        } catch {
            print("Failed to start playing:", error)
        }
    }
    
    func stopPlaying() {
        removeTimer()
        player?.stop()
        player = nil
        status = .waiting
    }
    
    func uploadVoice() async {
        try? await ProfileNetworkManager.shard.uploadVoice()
    }
}

extension RecordProfileViewModel {
    private func setupNotificationObservers() {
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                self?.handleAppDidEnterBackground() // 앱이 백그라운드로 갈 때 녹음/재생 정지
            }
            .store(in: &cancellables)
    }
    
    private func cleanUp() {
        // 타이머 정리
        removeTimer()
        
        // 녹음 정리
        if let recorder = recorder, recorder.isRecording {
            recorder.stop()
        }
        recorder = nil
        
        // 재생 정리
        if let player = player, player.isPlaying {
            player.stop()
        }
        player = nil
        
        // AVAudioSession 정리
        try? AVAudioSession.sharedInstance().setActive(false)
        
        // Combine 구독 정리
        cancellables.removeAll()
        
        status = .pending // 녹음 대기 상태로 전환
    }
    
    @objc private func handleAppDidEnterBackground() {
        // 백그라운드에서 녹음/재생 정지
        switch status {
        case .recording:
            stopRecording()
        case .playing:
            stopPlaying()
        default:
            break
        }
    }
}

extension RecordProfileViewModel: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopPlaying()
    }
}
