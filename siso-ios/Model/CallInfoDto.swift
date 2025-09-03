import Foundation

// 사용 목적: 알림으로 받은 핵심 통화 정보를 API 요청의 Body에 담아 보낼 때 사용.
// UI 표시에 필요한 닉네임, 프로필 사진 등은 포함하지 않음.

public struct CallInfoDto: Codable, Equatable, Identifiable {
    
    public init(id: Int, channelName: String, token: String, callerId: Int, receiverId: Int) {
        self.id = id
        self.channelName = channelName
        self.token = token
        self.callerId = callerId
        self.receiverId = receiverId
    }
    
    // 1. DTO 필드 정확하게 반영
    public let id: Int            // Long -> Int
    public let channelName: String  // ✅ channelId -> channelName 으로 수정
    public let token: String
    public let callerId: Int      // Long -> Int
    public let receiverId: Int    // Long -> Int
   
    
    // 3. 서버 JSON 키와 Swift 프로퍼티 이름이 다른 경우 매핑
    // Java는 보통 camelCase를 사용하므로 Swift와 이름이 일치합니다.
    enum CodingKeys: String, CodingKey {
        case id
        case channelName // ✅ channelId -> channelName 으로 수정
        case token
        case callerId
        case receiverId
    }
    
   
}
