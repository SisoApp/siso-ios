//
//  UserProfile.swift
//  profile
//
//  Created by 멘태 on 8/15/25.
//

import UIKit
import Combine
import model

public class UserProfile: ObservableObject {
    public static let empty: UserProfile = UserProfile(
        nickname: "",
        age: 0,
        sex: "",
        targetSex: "",
        profileImageUrl: [],
        interests: [],
        introduce: "",
        religion: "",
        smoking: false,
        drinking: "",
        meeting: [],
        mbti: "",
        location: ""
    )
    
    @Published var nickname: String // 닉네임
    @Published var age: Int // 나이
    @Published var sex: String // 성별
    @Published var targetSex: String // 대상 성별
    @Published var profileImages: [UIImage] // 프로필 사진
    @Published var interests: [String] // 관심사
    @Published var introduce: String // 자기소개
    @Published var voice: Bool // 목소리
    @Published var religion: String // 종교
    @Published var smoking: Bool? // 흡연
    @Published var drinking: String // 음주
    @Published var meeting: [String] // 모임
    @Published var mbti: String // mbti
    @Published var location: String // 지역
    
    public init(nickname: String, age: Int, sex: String, targetSex: String,
                profileImageUrl: [UIImage], interests: [String], introduce: String,
                religion: String, smoking: Bool?, drinking: String,
                meeting: [String], mbti: String, location: String) {
        self.nickname = nickname
        self.age = age
        self.sex = sex
        self.targetSex = targetSex
        self.profileImages = profileImageUrl
        self.interests = interests
        self.introduce = introduce
        self.voice = false
        self.religion = religion
        self.smoking = smoking
        self.drinking = drinking
        self.meeting = meeting
        self.mbti = mbti
        self.location = location
    }
    
    static func convertToDTO(_ userProfile: UserProfile) -> UserProfileDTO {
        let drinkingCapacity: DrinkingCapacity? = .init(rawValue: userProfile.drinking)
        let religion: Religion? = .init(rawValue: userProfile.religion)
        let sex: Sex? = .init(rawValue: userProfile.sex)
        let preferenceSex: PreferenceSex? = .init(rawValue: userProfile.targetSex)
        let mbti: Mbti? = .init(rawValue: userProfile.mbti)
        let location: String? = !userProfile.location.isEmpty ? userProfile.location : nil
        let introduce: String? = !userProfile.introduce.isEmpty ? userProfile.introduce : nil
        
        let meetings: [Meeting]? = userProfile.meeting.isEmpty
            ? nil
            : userProfile.meeting.compactMap { Meeting(rawValue: $0) }
        
        let profileDto: UserProfileDTO = UserProfileDTO(
            drinkingCapacity: drinkingCapacity,
            religion: religion,
            smoke: userProfile.smoking,
            age: userProfile.age,
            nickname: userProfile.nickname,
            introduce: introduce,
            location: location,
            sex: sex,
            preferenceSex: preferenceSex,
            mbti: mbti,
            meetings: meetings
        )
        
        return profileDto
    }
    
    static func convertFromDTO(_ userProfileDTO: UserProfileDTO) -> UserProfile {
        return UserProfile(
            nickname: userProfileDTO.nickname,
            age: userProfileDTO.age,
            sex: userProfileDTO.sex?.rawValue ?? "",
            targetSex: userProfileDTO.preferenceSex?.rawValue ?? "",
            profileImageUrl: [],
            interests: [],
            introduce: userProfileDTO.introduce ?? "",
            religion: userProfileDTO.religion?.rawValue ?? "",
            smoking: userProfileDTO.smoke,
            drinking: userProfileDTO.drinkingCapacity?.rawValue ?? "",
            meeting: userProfileDTO.meetings?.map { $0.rawValue } ?? [],
            mbti: userProfileDTO.mbti?.rawValue ?? "",
            location: userProfileDTO.location ?? ""
        )
    }
}
