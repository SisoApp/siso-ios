import Foundation

// 사용 목적: 알림으로 받은 핵심 통화 정보를 API 요청의 Body에 담아 보낼 때 사용.
// UI 표시에 필요한 닉네임, 프로필 사진 등은 포함하지 않음.

public struct CallInfoDto: Codable, Equatable, Identifiable {
    
    
    // 1. DTO 필드 정확하게 반영
    public let id: Int            // Long -> Int
    public let channelName: String  // ✅ channelId -> channelName 으로 수정
    public let token: String
    public let callerId: Int      // Long -> Int
    public let receiverId: Int    // Long -> Int
    public let firstCall: Bool    // ✅ 누락되었던 firstCall 필드 추가
    public let profileImageUrl: String?
    public let nickname: String
    
    // 3. 서버 JSON 키와 Swift 프로퍼티 이름이 다른 경우 매핑
    // Java는 보통 camelCase를 사용하므로 Swift와 이름이 일치합니다.
    enum CodingKeys: String, CodingKey {
        case id
        case channelName // ✅ channelId -> channelName 으로 수정
        case token
        case callerId
        case receiverId
        case firstCall   // ✅ 누락되었던 firstCall 키 추가
        case profileImageUrl
        case nickname
    }
    
   
}
