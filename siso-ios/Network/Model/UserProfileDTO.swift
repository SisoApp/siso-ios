//
//  UserProfileDTO.swift
//  network
//
//  Created by jdios on 8/29/25.
//

import Foundation

/// 서버에 사용자 프로필 생성을 요청할 때 사용하는 데이터 모델
public struct UserProfileRequestDto: Codable {
    public let drinkingCapacity: DrinkingCapacity?
    public let religion: Religion?
    public let smoke: Bool?
    public let age: Int
    public let nickname: String
    public let introduce: String?
    public let location: String?
    public let sex: Sex?
    public let preferenceSex: PreferenceSex?
    public let mbti: Mbti?
    public let meetings: [Meeting]?
    
    public init(from parameters: [String: Any]) {
        self.age = parameters["age"] as? Int ?? 0
        self.nickname = parameters["nickname"] as? String ?? ""
        
        if let sexString = parameters["sex"] as? String {
            self.sex = Sex(rawValue: sexString)
        } else {
            self.sex = nil
        }
        
        if let preferenceSexString = parameters["preferenceSex"] as? String {
            self.preferenceSex = PreferenceSex(rawValue: preferenceSexString)
        } else {
            self.preferenceSex = nil
        }
        
        if let drinkingString = parameters["drinkingCapacity"] as? String {
            self.drinkingCapacity = DrinkingCapacity(rawValue: drinkingString)
        } else {
            self.drinkingCapacity = nil
        }
        
        if let religionString = parameters["religion"] as? String {
            self.religion = Religion(rawValue: religionString)
        } else {
            self.religion = nil
        }
        
        if let mbtiString = parameters["mbti"] as? String {
            self.mbti = Mbti(rawValue: mbtiString)
        } else {
            self.mbti = nil
        }
        
        self.smoke = parameters["smoke"] as? Bool
        self.introduce = parameters["introduce"] as? String
        self.location = parameters["location"] as? String
        
        if let meetingStrings = parameters["meetings"] as? [String] {
            self.meetings = meetingStrings.compactMap { Meeting(rawValue: $0) }
        } else {
            self.meetings = nil
        }
    }
    
}

public struct UserProfileResponseDTO: Codable {
    let success: Bool
    let code: String
    let message: String
    let data: UserProfileRequestDto
}

// MARK: - Enums (별도의 파일에 관리하는 것을 추천)

public enum DrinkingCapacity: String, Codable, CaseIterable {
    case frequently = "FREQUENTLY"
    case occasionally = "OCCASIONALLY"
    case never = "NEVER"
    
    public var description: String {
        switch self {
        case .frequently: return "자주 마셔요 (주 3회 이상)"
        case .occasionally: return "가끔 마셔요 (주 1회 ~ 한 달에 한 번)"
        case .never: return "전혀 안 해요"
        }
    }
    
    public static func description(for rawValue: String) -> String? {
        guard let capacity: DrinkingCapacity = .init(rawValue: rawValue) else { return nil }
        return capacity.description
    }
}

public enum Religion: String, Codable, CaseIterable {
    case none = "NONE"
    case christianity = "CHRISTIANITY"
    case catholic = "CATHOLIC"
    case buddhism = "BUDDHISM"
    case other = "OTHER"
    
    public var description: String {
        switch self {
        case .none: return "무교"
        case .christianity: return "기독교"
        case .catholic: return "천주교"
        case .buddhism: return "불교"
        case .other: return "기타 종교"
        }
    }
    
    public static func description(for rawValue: String) -> String? {
        guard let religion: Religion = .init(rawValue: rawValue) else { return nil }
        return religion.description
    }
}

public enum PreferenceContact: String, Codable, CaseIterable {
    case kakaoTalk = "KAKAO_TALK"
    case instagram = "INSTAGRAM"
    // ... 다른 케이스들
}

public enum Sex: String, Codable, CaseIterable {
    case male = "MALE"
    case female = "FEMALE"
    
    public var description: String {
        switch self {
        case .male: return "남성"
        case .female: return "여성"
        }
    }
    
    public static func description(for rawValue: String) -> String? {
        guard let sex: Sex = .init(rawValue: rawValue) else { return nil }
        return sex.description
    }
}

public enum PreferenceSex: String, Codable, CaseIterable {
    case male = "MALE"
    case female = "FEMALE"
    case other = "OTHER"
    
    public var description: String {
        switch self {
        case .male: return "남성"
        case .female: return "여성"
        case .other: return "상관없음"
        }
    }
    
    public static func description(for rawValue: String) -> String? {
        guard let preferenceSex: PreferenceSex = .init(rawValue: rawValue) else { return nil }
        return preferenceSex.description
    }
}

public struct MainProfileImage: Codable {
    let url: String
    let isMain: Bool
}

public enum Mbti: String, Codable, CaseIterable {
    case infp = "INFP"
    case entj = "ENTJ"
    // ... 다른 케이스들
}

public enum Meeting: String, Codable, CaseIterable {
    case clubActivity = "CLUB_ACTIVITY"
    case volunteerActivity = "VOLUNTEER_ACTIVITY"
    case hobbyGroup = "HOBBY_GROUP"
    case cultureLife = "CULTURE_LIFE"
    case togetherSports = "TOGETHER_SPORTS"
    case hiking = "HIKING"
    case foodTrip = "FOOD_TRIP"
    case teaTime = "TEA_TIME"
    case travel = "TRAVEL"
    case photoTrip = "PHOTO_TRIP"
    case golf = "GOLF"
    case movie = "MOVIE"
    case concert = "CONCERT"
    case exhibition = "EXHIBITION"
    case hikingMate = "HIKING_MATE"
    case cyclingMate = "CYCLING_MATE"
    case bookClub = "BOOK_CLUB"
    case talkClub = "TALK_CLUB"
    case hobbyShare = "HOBBY_SHARE"
    case newConnection = "NEW_CONNECTION"
    case communication = "COMMUNICATION"
    case togetherTime = "TOGETHER_TIME"
    case makeConnection = "MAKE_CONNECTION"
    
    public var description: String {
        switch self {
        case .clubActivity: return "#동호회활동"
        case .volunteerActivity: return "#봉사활동"
        case .hobbyGroup: return "#취미모임"
        case .cultureLife: return "#문화생활"
        case .togetherSports: return "#함께운동"
        case .hiking: return "#산책동행"
        case .foodTrip: return "#맛집탐방"
        case .teaTime: return "#차한잔"
        case .travel: return "#여행동행"
        case .photoTrip: return "#사진동행"
        case .golf: return "#골프동반"
        case .movie: return "#영화동행"
        case .concert: return "#콘서트동행"
        case .exhibition: return "#전시회동행"
        case .hikingMate: return "#등산메이트"
        case .cyclingMate: return "#자전거메이트"
        case .bookClub: return "#독서모임"
        case .talkClub: return "#토크모임"
        case .hobbyShare: return "#취향공유"
        case .newConnection: return "#새로운인연"
        case .communication: return "#소통해요"
        case .togetherTime: return "#함께하는시간"
        case .makeConnection: return "#인연만들기"
        }
    }
}

public enum Interest: String, CodingKey, CaseIterable {
    // 문화 & 예술 (Culture & Arts)
    case music = "MUSIC"
    case art = "ART"
    case classicalMusic = "CLASSICAL_MUSIC"
    case reading = "READING"
    case performances = "PERFORMANCES"
    // 취미 & 여가 (Hobbies & Leisure)
    case travel = "TRAVEL"
    case hiking = "HIKING"
    case golf = "GOLF"
    case fishing = "FISHING"
    case cooking = "COOKING"
    case photography = "PHOTOGRAPHY"
    case movies = "MOVIES"
    // 자기 계발 (Self-Improvement)
    case languageLearning = "LANGUAGE_LEARNING"
    case financialManagement = "FINANCIAL_MANAGEMENT"
    case volunteering = "VOLUNTEERING"
    case healthFitness = "HEALTH_FITNESS"
    
    // 일상 & 교류 (Daily Life & Socializing)
    case pets = "PETS"
    case diningOut = "DINING_OUT"
    case havingTea = "HAVING_TEA"
    case chatting = "CHATTING"
    
    public var description: String {
        switch self {
            // 취미 & 여가
        case .travel: return "여행"
        case .hiking: return "등산"
        case .golf: return "골프"
        case .fishing: return "낚시"
        case .cooking: return "요리"
        case .photography: return "사진 촬영"
        case .movies: return "영화 시청"
            
            // 문화 & 예술
        case .music: return "음악 감상"
        case .art: return "미술 전시회 관람"
        case .classicalMusic: return "클래식"
        case .reading: return "독서"
        case .performances: return "공연 관람"
            
            // 자기 계발
        case .languageLearning: return "외국어 학습"
        case .financialManagement: return "재테크"
        case .volunteering: return "자원 봉사"
        case .healthFitness: return "건강/운동"
            
            // 일상 & 교류
        case .pets: return "반려 동물"
        case .diningOut: return "맛집 탐방"
        case .havingTea: return "차 마시기"
        case .chatting: return "수다/이야기"
        }
    }
}

public enum Provider: String, Codable {
    case kakao = "KAKAO"
    case apple = "APPLE"
}
