//
//  ProfileViewModel.swift
//  network
//
//  Created by 멘태 on 8/27/25.
//

import Foundation
import network
import model

public extension ProfileView {
    class ProfileViewModel {
        private var profile: UserProfileDTO?
        private var images: [ImageDTO]?
        private var voice: VoiceDTO?
        private var interests: [Interest]?
        
        var nickname: String {
            return profile?.nickname ?? ""
        }
        
        var age: String {
            return profile?.age.description ?? ""
        }
        
        var introduce: String {
            return profile?.introduce ?? ""
        }
        
        var location: String {
            return profile?.location ?? ""
        }
        
        var smoke: Bool {
            return profile?.smoke ?? false
        }
        
        var sex: String? {
            return profile?.sex?.rawValue
        }
        
        var preferenceSex: String? {
            return profile?.preferenceSex?.rawValue
        }
        
        var drinkingCapacity: String {
            return profile?.drinkingCapacity?.rawValue ?? ""
        }
        
        var religion: String {
            return profile?.religion?.rawValue ?? ""
        }
        
        var mbti: String {
            return profile?.mbti?.rawValue ?? ""
        }
        
        var meetings: [String] {
            return profile?.meetings?.map { $0.rawValue } ?? []
        }
        
        var interestArray: [String] {
            return interests?.map { $0.rawValue } ?? []
        }
        
        var voiceId: Int? {
            return voice?.id
        }
        
        var voiceDuration: Int {
            return voice?.duration ?? 0
        }
        
        var voiceUrl: String {
            return voice?.url ?? ""
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
        
        func setViewModel(profile: UserProfileDTO?, images: [ImageDTO]?, voice: VoiceDTO?, interests: [Interest]?) {
            self.profile = profile
            self.images = images
            self.voice = voice
            self.interests = interests
        }
        
        func fetchProfile() async {
            
        }
        
        func updateProfile(_ userProfile: UserProfile, completion: @escaping (UserProfileDTO) -> Void) async {
            guard let drinkingCapacity = DrinkingCapacity(rawValue: userProfile.drinking),
                  let religion = Religion(rawValue: userProfile.religion),
                  let sex = Sex(rawValue: userProfile.sex),
                  let preferenceSex = PreferenceSex(rawValue: userProfile.targetSex),
                  let mbti = Mbti(rawValue: userProfile.mbti) else { return }
            
            let meetings: [Meeting]? = userProfile.meeting.isEmpty
                ? nil
                : userProfile.meeting.compactMap { Meeting(rawValue: $0) }
            
            let request: UserProfileDTO = UserProfileDTO(
                drinkingCapacity: drinkingCapacity,
                religion: religion,
                smoke: userProfile.smoking,
                age: userProfile.age,
                nickname: userProfile.nickname,
                introduce: userProfile.introduce,
                location: userProfile.location,
                sex: sex,
                preferenceSex: preferenceSex,
                mbti: mbti,
                meetings: meetings
            )
            
            //관심사도 해야함
            
            try? await ProfileNetworkManager.shared.updateProfile(request) { profile in
                completion(profile)
            }
        }
        
        func updateInterests(_ userProfile: UserProfile) async {
            var request: [InterestRequestDTO] = []
            
            for interest in userProfile.interests {
                if let interestDTO = Interest(rawValue: interest) {
                    request.append(InterestRequestDTO(interest: interestDTO))
                }
            }
            
            try? await ProfileNetworkManager.shared.registerInterests(request)
        }
    }
}
