import Foundation

// ✨ 1. 서버의 PresenceStatus Enum을 Swift로 정의합니다.
// 서버에서 사용하는 문자열 값을 그대로 case로 만들어야 합니다. (예: "ONLINE", "OFFLINE")
public enum PresenceStatus: String, Codable, Equatable {
    case online = "ONLINE"
    case offline = "OFFLINE"
    case inCall = "IN_CALL" // 예시입니다. 서버의 실제 값을 확인하세요.
    // ... 기타 상태들
}


// 서버의 MatchingProfileResponseDto와 1:1로 매핑되는 구조체
public struct MatchingProfile: Codable, Equatable, Identifiable {
    public var id: Int {
        self.userId
    }
    
    
    // 1. DTO 필드를 정확하게 일치시킵니다.
    // Identifiable 프로토콜의 요구사항인 'id'를 기본 프로퍼티로 사용합니다.
    public let userId: Int // userId 대신 id를 직접 디코딩합니다.
    
    public let nickname: String
    public let age: Int
    
    // 서버에서 null을 보낼 가능성이 없다면 non-optional (String)이 더 좋습니다.
    // 여기서는 null 가능성을 열어두고 옵셔널로 유지합니다.
    public let location: String?
    public let interests: [String]
    public let introduce: String?
    public let imageUrls: [String]
    public let voiceSampleUrl: String?
    
    // ✅ 2. 누락되었던 presenseStatus 필드를 추가합니다.
    public let presenceStatus: PresenceStatus // presenseStatus -> presenceStatus (오타 수정)
    
    // 3. 서버 JSON 키와 Swift 프로퍼티 이름 매핑
    enum CodingKeys: String, CodingKey {
        case userId
        case nickname
        case age
        case location
        case interests
        case introduce
        case imageUrls
        case voiceSampleUrl
        case presenceStatus // presenseStatus -> presenceStatus (오타 수정)
    }

    /// 리오넬 메시를 테마로 한 샘플 프로필 데이터 (새로운 구조에 맞게 수정)
    public static let sampleMessi: MatchingProfile = .init(
        userId: 10, // 샘플용 고유 ID
        nickname: "리오넬 메시",
        age: 37,
        location: "아르헨티나 부에노스아이레스",
        interests: ["구토댄스", "메슬렁대기", "발롱도르 받기"],
        introduce: "안녕하세요! 축구와 가족을 사랑하는 평범한 사람입니다. 경기장 밖에서는 조용하지만, 좋은 사람들과 함께하는 맛있는 식사와 대화를 즐겨요. 함께 마테차 한잔하실 분 찾습니다. 🧉",
        imageUrls: ["https://picsum.photos/seed/messi/400/600"],
        voiceSampleUrl: nil, // 샘플 데이터에서는 nil 처리
        presenceStatus: .online // ✅ 샘플 데이터에도 추가
    )
}
