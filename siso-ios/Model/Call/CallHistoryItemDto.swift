import Foundation

/// 통화 기록 목록의 각 항목을 나타내는 DTO
public struct CallHistoryItemDto: Codable, Identifiable {
    public var id: String { channelName } // 목록에서 고유 식별을 위해 channelName 사용
    
    public let accepted: Bool
    public let token: String?
    public let channelName: String
    public let callerId: Int
    public let receiverId: Int
    public let callStatus: CallStatus // "ACCEPT", "DENY", "ENDED" 등
    public let duration: Int?
    
    // public let id: Int <- 추가될거임 내가 시킴
}
/// 서버로부터 받는 통화 상태를 나타내는 열거형
public enum CallStatus: String, Codable, Equatable, CaseIterable {
    
    /// 통화 요청 상태
    case requested = "REQUESTED"
    
    /// 통화 수락 상태
    case accept = "ACCEPT"
    
    /// 통화 거절 상태
    case deny = "DENY"
    
    /// 통화 종료 상태
    case ended = "ENDED"
    
    // --- 추가: UI 표시를 위한 편의 프로퍼티 ---
    
    /// UI에 표시할 한글 설명
    public var description: String {
        switch self {
        case .requested:
            return "통화 요청"
        case .accept:
            return "통화 승낙"
        case .deny:
            return "통화 거절"
        case .ended:
            return "통화 종료"
        }
    }
    
    /// 상태에 따라 표시할 시스템 아이콘 이름 (SF Symbols)
    public var systemIconName: String {
        switch self {
        case .requested:
            return "phone.arrow.up.right.fill"
        case .accept:
            return "phone.fill"
        case .deny:
            return "phone.down.fill"
        case .ended:
            return "phone.fill.badge.xmark"
        }
    }
}
