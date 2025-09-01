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
        
        var nickname: String {
            return profile?.nickname ?? ""
        }
        
        var age: String {
            return (profile?.age.description ?? "")  + "세"
        }
        
        var location: String {
            return profile?.location ?? ""
        }
        
        func setProfile(_ profile: UserProfileDTO?) {
            self.profile = profile
        }
    }
}


