//
//  ProfileViewModel.swift
//  network
//
//  Created by 멘태 on 8/27/25.
//

import Foundation
import network

public extension ProfileView {
    class ProfileViewModel {
        func registerProfile(_ userProfile: UserProfile) async {
            let parameters: [String: Any] = [
                "drinkingCapacity": userProfile.drinking,
                "religion": userProfile.religion,
                "smoke": false,
                "age": userProfile.age,
                "nickname": userProfile.nickname,
                "introduce": userProfile.introduce,
                "location": userProfile.location,
                "sex": userProfile.sex,
                "preferenceSex": userProfile.targetSex,
                "mbti": userProfile.mbti,
                "meetings": userProfile.meeting
            ]
            
            print(parameters)
            
            try? await ProfileNetworkManager.shared.registerProfile(parameters)
        }
    }
}
