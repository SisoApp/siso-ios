//
//  MyPageViewModel.swift
//  profile
//
//  Created by 멘태 on 8/27/25.
//

import Foundation
import model
import network

public extension MyPageView {
    @MainActor
    class MyPageViewModel: ObservableObject {
        @Published var profile: UserProfileDTO?
        @Published var images: [ImageDTO]?
        @Published var voice: VoiceDTO?
        @Published var interests: [Interest]?
        @Published var mainImageUrl: URL?
        
        var progress: Int {
            var result: Int = 0
            
            if let _ = voice, let _ = profile?.introduce, let _ = images {
                result += 10
            }
            
            if let location = profile?.location, !location.isEmpty {
                result += 30
            }
            
            if let _ = profile?.religion,
               let _ = profile?.drinkingCapacity,
               let _ = profile?.mbti {
                result += 30
            }
            
            if let interests = interests, !interests.isEmpty,
               let meetings = profile?.meetings, !meetings.isEmpty {
                result += 30
            }
        
            return result
        }
        
        func setViewModel(profile: UserProfileDTO?, images: [ImageDTO]?, voice: VoiceDTO?, interests: [Interest]?) {
            self.profile = profile
            self.images = images
            self.voice = voice
            self.interests = interests
        }
        
        func getImageUrl(_ images: [ImageDTO]?) async {
            guard let images = images else { return }
            try? await ImageNetworkManager.shared.getImageUrl(for: images[0].id) { [weak self] urlString in
                guard let url: URL = URL(string: urlString) else { return }
                self?.mainImageUrl = url
            }
        }
    }
}


