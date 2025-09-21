import Foundation

public struct ChatMessageResponseDTO: Codable, Identifiable, Equatable {
    public let id: Int
    public let chatRoomId: Int
    public let senderId: Int
    public let content: String
    public let createdAt: String // 또는 Date
    public let updatedAt: String // 또는 Date
    public let isDeleted: Bool

    // JSON의 키 이름과 Swift 프로퍼티 이름을 다르게 하고 싶을 때 사용합니다.
    // 여기서는 isDeleted를 위해 사용했습니다.
    enum CodingKeys: String, CodingKey {
        case id
        case chatRoomId
        case senderId
        case content
        case createdAt
        case updatedAt
        case isDeleted = "deleted" // JSON의 "deleted" 키를 "isDeleted" 프로퍼티에 매핑
    }
    
    public init(id: Int, chatRoomId: Int, senderId: Int, content: String, createdAt: String, updatedAt: String, isDeleted: Bool) {
        self.id = id
        self.chatRoomId = chatRoomId
        self.senderId = senderId
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isDeleted = isDeleted
    }
}
// MARK: - API 응답의 전체 구조 (SisoResponse)
// Generic을 사용하여 어떤 타입의 데이터든 담을 수 있도록 설계
public struct SisoResponse2<T: Codable>: Codable {
    public let status: Int
    public let data: T? // 데이터가 비어있을 수 있으므로 옵셔널(T?) 타입
    public let errorMessage: String? // 에러 메시지가 없을 수 있으므로 옵셔널(String?) 타입
}
