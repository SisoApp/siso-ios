//
//  AppSettings.swift
//  siso-ios
//
//  Created by jdios on 8/28/25.
//

import Foundation
import SwiftUI
import Combine

// 앱의 전역 설정을 관리하는 클래스
@MainActor
public class AppSettings: ObservableObject {
    // @AppStorage를 사용하면 UserDefaults의 "tutorialHasBeenWatched" 키와 이 프로퍼티가 자동으로 동기화됩니다.
    // 값이 변경되면 @Published 덕분에 SwiftUI 뷰가 자동으로 업데이트됩니다.
    @AppStorage("tutorialHasBeenWatched") public var tutorialHasBeenWatched: Bool = false
    
    // 앱에 로그인한 사용자의 프로필 정보를 UserDefaults에 저장합니다.
    @AppStorage("userProfile") private var userProfileData: Data?
    public var userProfile: UserProfileDTO? {
        get {
            guard let data = userProfileData,
                  let profile = try? JSONDecoder().decode(UserProfileDTO.self, from: data) else { return nil }
            return profile
        }
        set {
            if let profile = newValue,
               let data = try? JSONEncoder().encode(profile) {
                userProfileData = data
                print("내 프로필 UserDefaults 저장 성공: \(profile)")
            } else {
                userProfileData = nil
            }
        }
    }
    
    @AppStorage("interests") private var interestsData: Data?
    public var interests: [Interest]? {
        get {
            guard let data = interestsData,
                  let interests = try? JSONDecoder().decode([Interest].self, from: data) else { return nil }
            return interests
        }
        set {
            if let interests = newValue,
               let data = try? JSONEncoder().encode(interests) {
                interestsData = data
                print("내 관심사 UserDefaults 저장 성공: \(interests)")
            } else {
                interestsData = nil
            }
        }
    }
    
    @AppStorage("voice") private var voiceData: Data?
    public var voice: VoiceDTO? {
        get {
            guard let data = voiceData,
                  let voice = try? JSONDecoder().decode(VoiceDTO.self, from: data) else { return nil }
            return voice
        }
        set {
            if let voice = newValue,
               let data = try? JSONEncoder().encode(voice) {
                voiceData = data
                debugPrint("녹음파일 UserDefaults 저장 성공!: \(voice)")
            } else {
                voiceData = nil
            }
        }
    }
    
    @AppStorage("profileImages") private var profileImagesData: Data?
    public var profileImages: [ImageDTO]? {
        get {
            guard let data = profileImagesData,
                  let profileImages = try? JSONDecoder().decode([ImageDTO].self, from: data) else { return nil }
            return profileImages
        }
        set {
            if let profileImages = newValue,
               let data = try? JSONEncoder().encode(profileImages) {
                profileImagesData = data
                debugPrint("프로필 이미지 UserDefaults 저장 성공: \(profileImages)")
            } else {
                profileImagesData = nil
            }
        }
    }
    
    public init(){}
}
