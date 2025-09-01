//
//  UserProfileDTO.swift
//  network
//
//  Created by jdios on 8/29/25.
//

import Foundation

/// 서버에 사용자 프로필 생성을 요청할 때 사용하는 데이터 모델
public struct UserProfileRequestDto: Codable, Sendable {
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

public struct UserProfileResponse: Codable, Sendable {
    let success: Bool
    let code: String
    let message: String
    let data: UserProfileResponseDto
}

public struct UserProfileResponseDto: Codable, Sendable {
    public let drinkingCapacity: DrinkingCapacity?
    public let religion: Religion?
    public let smoke: Bool?
    public let age: Int
    public let nickname: String
    public let introduce: String?
    public let location: String?
    public let sex: Sex?
    public let preferenceSex: PreferenceSex?
    public let profileImage: MainProfileImage
    public let mbti: Mbti?
    public let meetings: [Meeting]?
}



// MARK: - Enums (별도의 파일에 관리하는 것을 추천)

public enum DrinkingCapacity: String, Codable, CaseIterable, Sendable {
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

public enum Religion: String, Codable, CaseIterable, Sendable {
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

public enum PreferenceContact: String, Codable, CaseIterable, Sendable {
    case kakaoTalk = "KAKAO_TALK"
    case instagram = "INSTAGRAM"
    // ... 다른 케이스들
}

public enum Sex: String, Codable, CaseIterable, Sendable {
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

public enum PreferenceSex: String, Codable, CaseIterable, Sendable {
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

public struct MainProfileImage: Codable, Sendable {
    let url: String
    let isMain: Bool
}

public enum Mbti: String, Codable, CaseIterable, Sendable {
    case infp = "INFP"
    case entj = "ENTJ"
    // ... 다른 케이스들
}

public enum Meeting: String, Codable, CaseIterable, Sendable {
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
    
    public static func description(for rawValue: String) -> String? {
        guard let meeting: Meeting = .init(rawValue: rawValue) else { return nil }
        return meeting.description
    }
}

public enum InterestCategory: String, CaseIterable, Sendable {
    case cultureArts = "CURTURE_ART"
    case hobbiesLeisure = "HOBBIES_LEISURE"
    case dailyLifeSocializing = "DAILY_LIFE_SOCIALIZING"
    
    public var description: String {
        switch self {
        case .cultureArts: return "문화 & 예술"
        case .hobbiesLeisure: return "운동 & 야외활동"
        case .dailyLifeSocializing: return "여가 & 취미"
        }
    }
    
    public static func description(for rawValue: String) -> String? {
        guard let interest: InterestCategory = .init(rawValue: rawValue) else { return nil }
        return interest.description
    }
}

public enum Interest: String, Codable, CaseIterable, Sendable {
    // 문화 & 예술
    case music = "MUSIC"
    case photography = "PHOTOGRAPHY"
    case calligraphy = "CALIGRAPHY"
    case writing = "WRITING"
    case playInstrument = "PLAY_INSTRUMENT"
    case movies = "MOVIES"
    case art = "ART"
    case classicalMusic = "CLASSICAL_MUSIC"
    case singing = "SINGING"
    case dance = "DANCE"
    
    // 운동 & 야외활동
    case hiking = "HIKING"
    case fishing = "FISHING"
    case yoga = "YOGA"
    case golf = "GOLF"
    case bike = "BIKE"
    case camping = "CAMPING"
    case swimming = "SWIMMING"
    case go = "GO"
    case bowling = "BOWLING"
    case tableTennis = "TABLE_TENNIS"
    case flower = "FLOWER"
    case drive = "DRIVE"
    
    // 여가 취미
    case reading = "READING"
    case baking = "BAKING"
    case sewing = "SEWING"
    case drawArt = "DRAWART"
    case travel = "TRAVEL"
    case goodRestaurant = "GOOD_RESTAURANT"
    case video = "VIDEO"
    case wine = "WINE"
    case cooking = "COOKING"
    case interior = "INTERIOR"
    
    public var description: String {
        switch self {
        case .music: return "#음악감상"
        case .photography: return "#사진촬영"
        case .calligraphy: return "#서예"
        case .writing: return "#글쓰기"
        case .playInstrument: return "#악기연주"
        case .movies: return "#영화감상"
        case .art: return "#미술 전시회 관람"
        case .classicalMusic: return "#클래식 감상"
        case .singing: return "#노래부르기"
        case .dance: return "#댄스"
            
        case .hiking: return "#등산"
        case .fishing: return "#낚시"
        case .yoga: return "#요가"
        case .golf: return "#골프"
        case .bike: return "#자전거"
        case .camping: return "#캠핑"
        case .swimming: return "#수영"
        case .go: return "#바둑"
        case .bowling: return "#볼링"
        case .tableTennis: return "#탁구"
        case .flower: return "#꽃꽃이"
        case .drive: return "#드라이브"
            
        case .reading: return "#독서"
        case .baking: return "#베이킹"
        case .sewing: return "#뜨개질"
        case .drawArt: return "#원예"
        case .travel: return "#여행"
        case .goodRestaurant: return "#맛집"
        case .video: return "#영상"
        case .wine: return "#와인"
        case .cooking: return "#요리"
        case .interior: return "#인테리어"
        }
    }
    
    public var category: InterestCategory {
        switch self {
        case .music, .photography, .calligraphy, .writing, .playInstrument, .movies, .art, .classicalMusic, .singing, .dance:
            return .cultureArts
        case .hiking, .fishing, .yoga, .golf, .bike, .camping, .swimming, .go, .bowling, .tableTennis, .flower, .drive:
            return .hobbiesLeisure
        case .reading, .baking, .sewing, .drawArt, .travel, .goodRestaurant, .video, .wine, .cooking, .interior:
            return .dailyLifeSocializing
        }
    }
    
    public static func description(for rawValue: String) -> String? {
        guard let interest: Interest = .init(rawValue: rawValue) else { return nil }
        return interest.description
    }
}

public enum Provider: String, Codable, Sendable {
    case kakao = "KAKAO"
    case apple = "APPLE"
}
