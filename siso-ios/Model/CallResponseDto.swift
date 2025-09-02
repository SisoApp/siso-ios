// model/CallDtos.swift 또는 유사한 파일에 추가

// 서버의 AgoraCallResponseDto와 일치
public struct CallResponseDto: Codable, Equatable {
    public let accepted: Bool
    public let token: String?
    public let channelName: String
    public let callerId: Int
    public let receiverId: Int
    public let callStatus: String // "ACCEPT", "DENY", "ENDED" 등
    public let duration: Int?
    public let callerProfile: UserProfileDto
    public let receiverProfile: UserProfileDto
    
    // CodingKeys는 서버의 key가 camelCase와 다를 경우에만 필요합니다.
    // 현재는 일치하므로 생략 가능합니다.
}

// 서버의 UserProfileDto와 일치
public struct UserProfileDto: Codable, Equatable {
    public let nickname: String
    public let age: Int
    public let location: String?
    public let interests: [Interest]
    public let profileImageUrl: String?
}
