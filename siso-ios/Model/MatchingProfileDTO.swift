
public struct MatchingProfile: Codable, Equatable, Identifiable {
    public init(from dto: UserProfileDto, userId: Int) {
            self.userId = userId
            self.nickname = dto.nickname
            self.age = dto.age
            self.location = dto.location
            self.interests = dto.interests
            
            // UserProfileDto에 없는 정보들은 기본값 또는 nil로 처리합니다.
            self.introduce = nil // 소개글 정보가 없으므로 nil
            self.imageUrls = [dto.profileImageUrl].compactMap { $0 } // profileImageUrl이 nil이 아니면 배열에 추가
            self.voiceSampleUrl = nil // 음성 샘플 정보가 없으므로 nil
            
            // presenceStatus는 알 수 없으므로, 기본값(예: .online)으로 설정하거나
            // 또는 API 응답에 이 정보가 추가되어야 합니다.
            // 여기서는 임의로 .online으로 설정하겠습니다.
            self.presenceStatus = .online
        }

    public init(
           userId: Int,
           nickname: String,
           age: Int,
           location: String?,
           interests: [Interest],
           introduce: String?,
           imageUrls: [String],
           voiceSampleUrl: String?,
           presenceStatus: PresenceStatus
       ) {
           self.userId = userId
           self.nickname = nickname
           self.age = age
           self.location = location
           self.interests = interests
           self.introduce = introduce
           self.imageUrls = imageUrls
           self.voiceSampleUrl = voiceSampleUrl
           self.presenceStatus = presenceStatus
       }
   
    
    // Identifiable 프로토콜을 위한 id 프로퍼티. userId 값을 사용합니다.
    public var id: Int {
        return self.userId
    }
    
    // DTO 필드를 정확하게 일치시킵니다.
    public let userId: Int
    public let nickname: String
    public let age: Int
    public let location: String?
    public let interests: [Interest]
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
        case presenceStatus = "presenseStatus" // "ce"를 가진 프로퍼티가 "se"를 가진 JSON 키에서 온다고 명시
    }
}

// PresenceStatus Enum은 그대로 사용하시면 됩니다.
public enum PresenceStatus: String, Codable, Equatable {
    case online = "ONLINE"
    case offline = "OFFLINE"
    case inCall = "IN_CALL"
}
