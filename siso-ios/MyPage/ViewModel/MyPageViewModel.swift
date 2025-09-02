//
//  MyPageViewModel.swift
//  profile
//
//  Created by 멘태 on 8/27/25.
//

import Foundation
import model

public extension MyPageView {
    @MainActor
    class MyPageViewModel: ObservableObject {
        @Published private var profile: UserProfileDTO?
        @Published private var images: [ImageDTO]?
        @Published private var voice: VoiceDTO?
        @Published private var interests: [Interest]?
        
        var nickname: String {
            return profile?.nickname ?? ""
        }
        
        var age: String {
            return (profile?.age.description ?? "")  + "세"
        }
        
        var location: String {
            return profile?.location ?? ""
        }
        
        var progress: Int {
            var result: Int = 0
            
            if let _ = voice, let _ = profile?.introduce, let _ = images {
                result += 10
            }
            
            if let _ = profile?.location {
                result += 30
            }
            
            if let _ = profile?.religion,
               let _ = profile?.drinkingCapacity,
               let _ = profile?.mbti {
                result += 30
            }
            
            if let _ = interests, let _ = profile?.meetings {
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
    }
}


