import Foundation
import model // UserProfileServer를 사용하기 위해 필요

public enum IntegrationPage: Hashable, Identifiable {
    // Auth
    case login
    case accept
    case welcome
    
    // Matching
    case home
    case tutorial
    
    // Profile
    case complete
    case location
    case religion
    case smoke
    case drink
    case personality
    case meeting
    case profile
    case signUp
    case interest
    case voice
    case image
    
    // MyPage
    case my
    case setting
    case notification
    
    // Call
    // ✨ [수정] manner 케이스는 어떤 상대방과의 통화인지 알아야 하므로
    // opponentProfile 연관값을 갖도록 수정합니다.
    case manner(opponentProfile: MatchingProfile)
    
    // ✨ [수정] connecting, calling, incomingCall을 'activeCall' 하나로 통합합니다.
    case activeCall
    
    case reportFeedbackPopup
    
    // Chat
    case main
    case detail
    case notificationChat
    
    // MARK: - Identifiable Conformance
    
    public var id: String {
        switch self {
        case .login: return "login"
        case .accept: return "accept"
        case .welcome: return "welcome"
        case .home: return "home"
        case .tutorial: return "tutorial"
        case .complete: return "complete"
        case .location: return "location"
        case .religion: return "religion"
        case .smoke: return "smoke"
        case .drink: return "drink"
        case .personality: return "personality"
        case .meeting: return "meeting"
        case .profile: return "profile"
        case .signUp: return "signUp"
        case .interest: return "interest"
        case .voice: return "voice"
        case .image: return "image"
        case .my: return "my"
        case .setting: return "setting"
        case .notification: return "notification"
        // ✨ [수정] manner 케이스의 ID는 상대방의 고유 ID를 포함하여 생성합니다.
        case .manner(let opponentProfile): return "manner-\(opponentProfile.id)"
        case .activeCall: return "activeCall"
        case .reportFeedbackPopup: return "reportFeedbackPopup"
        case .main: return "main"
        case .detail: return "detail"
        case .notificationChat: return "notificationChat"
        }
    }
    
    // MARK: - Hashable & Equatable Conformance
    
    // ✨ [수정] Equatable 구현을 id 기반으로 단순화하고, 모든 케이스를 처리하도록 수정합니다.
    public static func == (lhs: IntegrationPage, rhs: IntegrationPage) -> Bool {
        return lhs.id == rhs.id
    }
    
    // ✨ [수정] Hashable 구현을 id 기반으로 단순화합니다.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
