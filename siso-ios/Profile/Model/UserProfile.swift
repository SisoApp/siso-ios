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
        voice: ""
    )
    
    @Published var nickname: String // 닉네임
    @Published var age: String // 나이
    @Published var sex: String // 성별
    @Published var targetSex: String // 대상 성별
    @Published var profileImageUrl: [UIImage] // 프로필 사진
    @Published var interests: [String] // 관심사
    @Published var introduce: String // 자기소개
    @Published var voice: String // 목소리
    
    public init(nickname: String, age: String, sex: String, targetSex: String,
         profileImageUrl: [UIImage], interests: [String], introduce: String, voice: String) {
        self.nickname = nickname
        self.age = age
        self.sex = sex
        self.targetSex = targetSex
        self.profileImageUrl = profileImageUrl
        self.interests = interests
        self.introduce = introduce
        self.voice = voice
    }
}
