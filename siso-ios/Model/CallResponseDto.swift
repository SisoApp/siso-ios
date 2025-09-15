import Foundation

// MARK: - 서버 응답 DTOs

// 통화 수락/거절/종료 API의 응답 'data' 객체
public struct CallResponseDto: Codable, Equatable {
    public let accepted: Bool
    public let token: String?
    public let channelName: String
    public let callerId: Int
    public let receiverId: Int
    public let callStatus: CallStatus // ✅ String-Codable Enum
    public let duration: Int?
    public let callerProfile: UserProfileDto
    public let receiverProfile: UserProfileDto
}

// 통화 응답에 포함된 유저 프로필 객체
public struct UserProfileDto: Codable, Equatable {
    public let id: Int
    public let nickname: String
    public let age: Int
    public let location: String?      // ✅ 옵셔널 처리 (핵심)
    public let interests: [Interest]  // ✅ String-Codable Enum 배열
    public let profileImageUrl: String? // ✅ 옵셔널 처리 (핵심)
}


// MARK: - Codable Enums
