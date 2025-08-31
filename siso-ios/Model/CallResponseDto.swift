import Foundation

/// 서버에서 오는 통화 상태를 나타내는 열거형입니다.
public enum CallStatus: String, Codable {
    // 서버에서 사용하는 문자열 값과 일치해야 합니다. (예: "REQUESTED", "ACCEPT" 등)
    // 일반적으로 대문자 스네이크 케이스를 많이 사용하므로, case 이름은 소문자로 하되 CodingKey를 사용할 수 있습니다.
    // 여기서는 서버 값이 소문자라고 가정합니다.
    case requested
    case accept
    case deny
    case ended
}

/// 통화 관련 API 응답을 위한 DTO(Data Transfer Object)입니다.
public struct CallResponseDto: Codable, Equatable {
    
    // 1. Java DTO 필드 전체 반영
    public let accepted: Bool
    public let token: String
    public let channelName: String
    public let callerId: Int
    public let receiverId: Int
    public let callStatus: CallStatus
    public let duration: Int

    enum CodingKeys: String, CodingKey {
        case accepted
        case token
        case channelName
        case callerId
        case receiverId
        case callStatus
        case duration
    }
}
