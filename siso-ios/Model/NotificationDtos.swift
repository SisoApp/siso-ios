// NotificationDtos.swift

import Foundation

// MARK: - NotificationType Enum

/// 알림 타입을 나타내는 열거형
public enum NotificationType: String, Codable, Equatable {
    case MATCHING
    case MESSAGE
    case CALL
}

// MARK: - NotificationResponseDto

/// 알림 목록의 각 항목을 나타내는 DTO
public struct NotificationResponseDto: Codable, Equatable, Identifiable {
    public let id: Int
    public let receiverId: Int
    public let senderId: Int
    public let senderNickname: String
    public let title: String
    public let message: String
    public let url: String? // URL은 없을 수도 있으므로 옵셔널이 더 안전합니다.
    public let type: NotificationType
    public let isRead: Bool
    public let createdAt: String // 서버의 LocalDateTime은 String으로 받습니다.
    
    enum CodingKeys: String, CodingKey {
            case id, receiverId, senderId, senderNickname, title, message, url, type, createdAt
            case isRead = "read" // "read"라는 JSON 키를 isRead 프로퍼티에 매핑
        }
}

