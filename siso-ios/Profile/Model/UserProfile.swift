//
//  UserProfile.swift
//  profile
//
//  Created by 멘태 on 8/15/25.
//

import UIKit
import Combine

public class UserProfile: ObservableObject {
    public static let empty: UserProfile = UserProfile(
        nickname: "",
        age: "",
        sex: "",
        targetSex: "",
        profileImageUrl: [],
        interests: [],
        introduce: "",
        religion: "",
        smoking: "",
        drinking: "",
        meeting: [],
        mbti: "",
        location: ""
    )
    
    @Published var nickname: String // 닉네임
    @Published var age: String // 나이
    @Published var sex: String // 성별
    @Published var targetSex: String // 대상 성별
    @Published var profileImageUrl: [UIImage] // 프로필 사진
    @Published var interests: [String] // 관심사
    @Published var introduce: String // 자기소개
    @Published var voice: Bool // 목소리
    @Published var religion: String // 종교
    @Published var smoking: String // 흡연
    @Published var drinking: String // 음주
    @Published var meeting: [String] // 모임
    @Published var mbti: String // mbti
    @Published var location: String // 지역
    
    public init(nickname: String, age: String, sex: String, targetSex: String,
                profileImageUrl: [UIImage], interests: [String], introduce: String,
                religion: String, smoking: String, drinking: String,
                meeting: [String], mbti: String, location: String) {
        self.nickname = nickname
        self.age = age
        self.sex = sex
        self.targetSex = targetSex
        self.profileImageUrl = profileImageUrl
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
}
