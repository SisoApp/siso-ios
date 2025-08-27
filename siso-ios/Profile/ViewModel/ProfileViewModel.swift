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
        func getCompletionRate(_ userProfile: UserProfile) -> Int {
            var rate: Int = 0
            
            if !userProfile.nickname.isEmpty && userProfile.age != 0 {
                rate += 10
            }
            
            return rate 
        }
        
        func registerProfile(_ userProfile: UserProfile) async {
            let parameters: [String: Any] = [
                "drinkingCapacity": userProfile.drinking,
                "religion": userProfile.religion,
                "isSmoke": false,
                "age": userProfile.age,
                "nickname": userProfile.nickname,
                "introduce": userProfile.introduce,
                "location": userProfile.location,
                "sex": userProfile.sex,
                "preferenceSex": userProfile.targetSex
            ]
            
            try? await ProfileNetworkManager.shard.registerProfile(parameters)
        }
    }
}
