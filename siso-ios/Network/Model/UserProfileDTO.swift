//
//  UserProfileDTO.swift
//  network
//
//  Created by jdios on 8/29/25.
//

import Foundation

/// 서버에 사용자 프로필 생성을 요청할 때 사용하는 데이터 모델
public struct UserProfileRequestDto: Codable {
    public let drinkingCapacity: DrinkingCapacity
    public let religion: Religion
    public let smoke: Bool
    public let age: Int
    public let nickname: String
    public let introduce: String
    public let preferenceContact: PreferenceContact
    public let location: Location
    public let sex: Sex
    public let preferenceSex: PreferenceSex
    public let profileImageId: Int64 // Long은 Int64로 매핑
    public let mbti: Mbti
    public let meetings: [Meeting]
    
    // Swift에서는 프로퍼티 이름과 JSON 키가 다를 경우 CodingKeys를 사용합니다.
    // 만약 Java의 카멜케이스와 Swift의 카멜케이스가 동일하다면 이 부분은 필요 없습니다.
    private enum CodingKeys: String, CodingKey {
        case drinkingCapacity
        case religion
        case smoke
        case age
        case nickname
        case introduce
        case preferenceContact
        case location
        case sex
        case preferenceSex
        case profileImageId
        case mbti
        case meetings
    }
}

// MARK: - Enums (별도의 파일에 관리하는 것을 추천)

public enum DrinkingCapacity: String, Codable, CaseIterable {
    case notAtAll = "NOT_AT_ALL"
    case oneToTwoBottles = "ONE_TO_TWO_BOTTLES"
    // ... 다른 케이스들
}

public enum Religion: String, Codable, CaseIterable {
    case christianity = "CHRISTIANITY"
    case buddhism = "BUDDHISM"
    // ... 다른 케이스들
}

public enum PreferenceContact: String, Codable, CaseIterable {
    case kakaoTalk = "KAKAO_TALK"
    case instagram = "INSTAGRAM"
    // ... 다른 케이스들
}

public enum Sex: String, Codable, CaseIterable {
    case male = "MALE"
    case female = "FEMALE"
}

public enum PreferenceSex: String, Codable, CaseIterable {
    case male = "MALE"
    case female = "FEMALE"
    case both = "BOTH"
}

public enum Location: String, Codable, CaseIterable {
    case seoul = "SEOUL"
    case busan = "BUSAN"
    // ... 다른 케이스들
}

public enum Mbti: String, Codable, CaseIterable {
    case infp = "INFP"
    case entj = "ENTJ"
    // ... 다른 케이스들
}

public enum Meeting: String, Codable, CaseIterable {
    case coffee = "COFFEE"
    case meal = "MEAL"
    // ... 다른 케이스들
}

public enum Provider: String, Codable {
    case kakao = "KAKAO"
    case apple = "APPLE"
}
