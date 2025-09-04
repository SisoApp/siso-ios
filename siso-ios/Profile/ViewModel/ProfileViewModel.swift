//
//  ProfileViewModel.swift
//  network
//
//  Created by 멘태 on 8/27/25.
//

import AVFoundation
import Foundation
import Combine
import network
import model

public extension ProfileView {
    class ProfileViewModel: ObservableObject {
        @Published var profile: UserProfileDTO?
        @Published var images: [ImageDTO]?
        @Published var interests: [Interest]?
        
        @Published var voice: VoiceDTO?
        @Published var status: RecordStatus = .waiting
        @Published var playTime: Int = 0
        
        private var urlPlayer: AVPlayer?
        private var timer: Timer.TimerPublisher?
        private var cancellables: Set<AnyCancellable> = .init()
        
        var smoke: Bool? {
            return profile?.smoke
        }
        
        var smokeDescription: String {
            if let smoke = profile?.smoke {
                switch smoke {
                case true:
                    return "흡연자"
                case false:
                    return "비흡연자"
                }
            }
            
            return ""
        }
        
        var voiceTimeText: String {
            if let voice = voice {
                let text: Int = status == .waiting ? voice.duration : playTime
                return String(format: "%02d", text)
            } else {
                return "-"
            }
        }
        
        var sexOptions: [(String, String)] {
            return ProfileOptions.getSexOptions()
        }
        
        var preferenceSexOptions: [(String, String)] {
            return ProfileOptions.getPreferenceSexOptions()
        }
        
        func getReligionDescription(for rawValue: String) -> String {
            return ProfileOptions.getReligionDescription(rawValue) ?? ""
        }
        
        func getDrinkingCapacityDescription(for rawValue: String) -> String {
            return ProfileOptions.getDrinkingCapacityDescription(rawValue) ?? ""
        }
        
        func getInterestDescriptions(for rawValues: [String]) -> [String] {
            var descriptions: [String] = []
            
            for rawValue in rawValues {
                descriptions.append(ProfileOptions.getInterestDescription(rawValue) ?? "")
            }
            
            return descriptions
        }
        
        func getMettingDescriptions(for rawValues: [String]) -> [String] {
            var descriptions: [String] = []
            
            for rawValue in rawValues {
                descriptions.append(ProfileOptions.getMeetingDescription(rawValue) ?? "")
            }
            
            return descriptions
        }
        
        func setViewModel() async {
            async let imageTask = try? await ImageNetworkManager.shared.getMyImages()
            async let profileTask: UserProfileDTO? = try? await ProfileNetworkManager.shared.getCurrentUserProfile()
            async let voiceTask: VoiceDTO? = try? await VoiceNetworkManager.shared.getMyVoice()
            
            let (fetchedImages, fetchedProfile, fetchedVoice) = await (imageTask, profileTask, voiceTask)
            
            await MainActor.run {
                self.images = fetchedImages
                self.profile = fetchedProfile
                self.voice = fetchedVoice
            }
        }
        
        func updateProfile(_ userProfile: UserProfile, completion: @escaping (UserProfileDTO) -> Void) async {
            let request: UserProfileDTO = UserProfile.convertToDTO(userProfile)
            
            try? await ProfileNetworkManager.shared.updateProfile(request) { profile in
                completion(profile)
            }
        }
        
        func updateInterests(_ userProfile: UserProfile) async {
            guard userProfile.interests.count > 0 else { return }
            
            var request: [InterestRequestDTO] = []
            
            for interest in userProfile.interests {
                if let interestDTO = Interest(rawValue: interest) {
                    request.append(InterestRequestDTO(interest: interestDTO))
                }
            }
            
            try? await ProfileNetworkManager.shared.registerInterests(request)
        }
        
        // MARK: - 녹음 관련 메서드
        func startTimer() {
            guard let voice = voice else { return }
            
            removeTimer() // 기존 타이머 정리
            
            timer = Timer.publish(every: 1.0, on: .main, in: .common)
            playTime = 0
            
            timer?.autoconnect()
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    
                    if self.playTime < voice.duration {
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
        
        func startPlaying() {
            guard let voice = voice,
                  let url = URL(string: voice.presignedUrl) else { return }
            urlPlayer = AVPlayer(url: url)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(urlPlayerDidFinishPlaying),
                name: .AVPlayerItemDidPlayToEndTime,
                object: urlPlayer?.currentItem
            )
            
            startTimer()
            urlPlayer?.play()
            status = .playing
        }
        
        func stopPlaying() {
            removeTimer()
            
            urlPlayer?.pause()
            urlPlayer = nil
            
            status = .waiting
        }
        
        @objc func urlPlayerDidFinishPlaying() {
            stopPlaying()
        }
    }
}
