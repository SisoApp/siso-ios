import Foundation

public enum FCMType: Codable {
    case call, chat
}

public struct FCMDTO: Codable, Equatable, Identifiable {
    
    // 1. DTO 필드 반영
    public let id: Int // CallInfoDto의 id (Long -> Int)
    public let channelId: String
    public let token: String
    public let callerId: Int // Long -> Int
    public let receiverId: Int // Long -> Int
    public let type: FCMType
    
    // 3. 서버 JSON 키와 Swift 프로퍼티 이름이 다른 경우 매핑 (현재는 동일하지만 예시로 포함)
    enum CodingKeys: String, CodingKey {
        case id
        case channelId
        case token
        case callerId
        case receiverId
        case type
    }
    
    // Identifiable 프로토콜 준수를 위해 id 프로퍼티를 그대로 사용합니다.
}
