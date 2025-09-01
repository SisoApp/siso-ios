public struct MatchingProfile: Codable, Equatable, Identifiable {
    // Identifiable 프로토콜을 위한 id 프로퍼티. userId 값을 사용합니다.
    public var id: Int {
        return self.userId
    }
    
    // DTO 필드를 정확하게 일치시킵니다.
    public let userId: Int
    public let nickname: String
    public let age: Int
    public let location: String?
    public let interests: [String]
    public let introduce: String?
    public let imageUrls: [String]
    public let voiceSampleUrl: String?
    
    // ✅ Swift에서는 'presence' (ce) 스펠링을 사용하는 것이 더 자연스럽습니다.
    public let presenceStatus: PresenceStatus
    
    // 서버 JSON 키와 Swift 프로퍼티 이름 매핑
    enum CodingKeys: String, CodingKey {
        case userId
        case nickname
        case age
        case location
        case interests
        case introduce
        case imageUrls
        case voiceSampleUrl
        
        // ▼▼▼▼▼ 바로 이 부분이 핵심 수정 사항입니다! ▼▼▼▼▼
        // Swift 프로퍼티 이름(presenceStatus)과 서버 JSON 키 이름("presenseStatus")을 연결합니다.
        case presenceStatus = "presenseStatus" // "ce"를 가진 프로퍼티가 "se"를 가진 JSON 키에서 온다고 명시
    }

    // 샘플 데이터는 수정할 필요 없이 잘 동작합니다.
    public static let sampleMessi: MatchingProfile = .init(
        userId: 10,
        nickname: "리오넬 메시",
        age: 37,
        location: "아르헨티나 부에노스아이레스",
        interests: ["구토댄스", "메슬렁대기", "발롱도르 받기"],
        introduce: "안녕하세요!...",
        imageUrls: ["https://picsum.photos/seed/messi/400/600"],
        voiceSampleUrl: nil,
        presenceStatus: .online
    )
}

// PresenceStatus Enum은 그대로 사용하시면 됩니다.
public enum PresenceStatus: String, Codable, Equatable {
    case online = "ONLINE"
    case offline = "OFFLINE"
    case inCall = "IN_CALL"
}
