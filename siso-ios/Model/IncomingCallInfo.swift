import Foundation

public struct IncomingCallInfo: Codable, Equatable, Identifiable {
    
    // 1. DTO 필드 반영
    public let id: Int // CallInfoDto의 id (Long -> Int)
    public let channelName: String
    public let token: String
    public let callerId: Int // Long -> Int
    public let receiverId: Int // Long -> Int
    
    // 2. UI 표시를 위한 상대방 프로필 정보
    // 이 정보는 서버 페이로드에 포함될 수도 있고, 아닐 수도 있습니다.
    // 포함되지 않는 경우를 대비해 옵셔널(Optional)로 선언합니다.
    public let opponentProfile: MatchingProfile?
    
    // 3. 서버 JSON 키와 Swift 프로퍼티 이름이 다른 경우 매핑 (현재는 동일하지만 예시로 포함)
    enum CodingKeys: String, CodingKey {
        case id
        case channelName
        case token
        case callerId
        case receiverId
        case opponentProfile // 서버에서도 'opponentProfile' 키로 MatchingProfile 객체를 내려준다고 가정
    }
    
    // Identifiable 프로토콜 준수를 위해 id 프로퍼티를 그대로 사용합니다.
}
