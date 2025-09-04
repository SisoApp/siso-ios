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
    class ProfileViewModel: ObservableObject {
        @Published var profile: UserProfileDTO?
        var images: [ImageDTO]?
        var voice: VoiceDTO?
        var interests: [Interest]?
        @Published var mainImageUrl: URL?
        
        var smoke: Bool? {
            return profile?.smoke
        }
        
        var smokeDescription: String {
            if let smoke = profile?.smoke {
                switch smoke {
                case true:
                    return "흡연자"
                case false:
                    return "비흡연자"
                }
            }
            
            return ""
        }
        
        var voiceId: Int? {
            return voice?.id
        }
        
        var voiceDuration: Int {
            return voice?.duration ?? 0
        }
        
        var voiceUrl: String {
            return voice?.presignedUrl ?? ""
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
        
        func getMyProfile() async {
            let profile: UserProfileDTO? = try? await ProfileNetworkManager.shared.getCurrentUserProfile()
            await MainActor.run {
                self.profile = profile
            }
        }
        
        func updateProfile(_ userProfile: UserProfile, completion: @escaping (UserProfileDTO) -> Void) async {
            let request: UserProfileDTO = UserProfile.convertToDTO(userProfile)
            
            try? await ProfileNetworkManager.shared.updateProfile(request) { profile in
                completion(profile)
            }
        }
        
        func updateInterests(_ userProfile: UserProfile) async {
            guard userProfile.interests.count > 0 else { return }
            
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
