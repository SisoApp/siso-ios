//
//  ProfileOptions.swift
//  profile
//
//  Created by 멘태 on 8/31/25.
//

import Foundation
import network

struct ProfileOptions {
    static func getSexOptions() -> [(String, String)] {
        return Sex.allCases.map { ($0.rawValue, $0.description) }
    }
    
    static func getSexDescription(for rawValue: String) -> String? {
        guard let sex: Sex = .init(rawValue: rawValue) else { return nil }
        return sex.description
    }
    
    static func getPreferenceSexOptions() -> [(String, String)] {
        return PreferenceSex.allCases.map { ($0.rawValue, $0.description) }
    }
    
    static func getPreferenceSexDescription(for rawValue: String) -> String? {
        guard let preferenceSex: PreferenceSex = .init(rawValue: rawValue) else { return nil }
        return preferenceSex.description
    }
    
    static func getDrinkingCapacityOptions() -> [(String, String)] {
        return DrinkingCapacity.allCases.map { ($0.rawValue, $0.description) }
    }
    
    static func getDrinkingCapacityDescription(rawValue: String) -> String? {
        return DrinkingCapacity.description(for: rawValue)
    }
    
    static func getReligionOptions() -> [(String, String)] {
        return Religion.allCases.map { ($0.rawValue, $0.description) }
    }
    
    static func getReligionDescription(rawValue: String) -> String? {
        return Religion.description(for: rawValue)
    }
    
    static func getMeetingOptions() -> [(String, String)] {
        return Meeting.allCases.map { ($0.rawValue, $0.description) }
    }
    
    static func getMeetingDescription(rawValue: String) -> String? {
        return Meeting.description(for: rawValue)
    }
    
    static func getInterestOptions() -> [(InterestCategory, [(String, String)])] {
        return InterestCategory.allCases.map { category in
            let options = Interest.allCases
                .filter { $0.category == category }
                .map { ($0.rawValue, $0.description) }
            return (category, options)
        }
    }
    
    static func getInterestDescription(rawValue: String) -> String? {
        return Interest.description(for: rawValue)
    }
    
    static func getInterestCategoryDescription(rawValue: String) -> String? {
        print(rawValue)
        return InterestCategory.description(for: rawValue)
    }
}
