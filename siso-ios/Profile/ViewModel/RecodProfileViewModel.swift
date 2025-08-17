//
//  RecodProfileViewModel.swift
//  profile
//
//  Created by 멘태 on 8/16/25.
//

import AVFoundation
import Combine
import SwiftUI

enum RecordStatus {
    case pending, recording, waiting, playing
}

class RecordProfileViewModel: NSObject, ObservableObject {
    @ObservedObject private var userProfile: UserProfile
    @Published var isRecoding: Bool = false
    @Published var isPlaying: Bool = false
    @Published var status: RecordStatus = .pending
    @Published var playTime: Int = 0
    
    private var recoder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    private var fileName: String = "voice.m4a"
    
    var timer: Timer.TimerPublisher?
    var cancellable: Cancellable?
    
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
    }
    
    func startTimer(max: Int = 20) {
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
        playTime = 0
        
        cancellable = timer?.autoconnect().sink { [weak self] _ in
            guard let self = self else { return }
            
            if self.playTime < max {
                self.playTime += 1
            } else {
                self.stopTimer()
            }
        }
    }
    
    func stopTimer() {
        cancellable?.cancel()
        cancellable = nil
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
            recoder = try AVAudioRecorder(url: audioFileUrl, settings: settings)
            recoder?.record()
            startTimer()
            isRecoding = true
        } catch {
            print("Failed to start recording:", error)
        }
    }
    
    func stopRecording() {
        stopTimer()
        recoder?.stop()
        isRecoding = false
        status = .waiting
        userProfile.voice = true
    }
    
    func startPlaying() {
        do {
            try player = AVAudioPlayer(contentsOf: audioFileUrl)
            startTimer()
            player?.delegate = self
            player?.play()
            status = .playing
            isPlaying = true
        } catch {
            print("Failed to start playing:", error)
        }
    }
    
    func stopPlaying() {
        isPlaying = false
        status = .waiting
    }
}

extension RecordProfileViewModel: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopTimer()
        status = .waiting
    }
}
