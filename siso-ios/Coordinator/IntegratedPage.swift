import Foundation
import model

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

    // MyPage
    case my
    case setting
    case notification

    // Call
    case manner(opponentProfile: UserProfileServer)
    case activeCall
    case reportFeedbackPopup
    
    // Chat
    case main
    case detail

    // MARK: - Identifiable Conformance
    
    /// Identifiable 프로토콜을 준수하기 위한 id 프로퍼티입니다.
    /// 각 케이스를 고유하게 식별할 수 있는 안정적인 값을 반환합니다.
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
        case .my: return "my"
        case .setting: return "setting"
        case .notification: return "notification"
        // 연관값이 있는 케이스는 연관값의 고유 ID를 포함하여 ID를 생성합니다.
        case .manner(let opponentProfile): return "manner-\(opponentProfile.id)"
        case .activeCall: return "activeCall"
        case .reportFeedbackPopup: return "reportFeedbackPopup"
        case .main: return "main"
        case .detail: return "detail"
        }
    }
    
    // MARK: - Hashable Conformance
    
    /// Hashable 프로토콜을 준수하기 위한 메서드입니다.
    /// 연관값이 있는 케이스도 올바르게 해싱되도록 직접 구현합니다.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id) // Identifiable의 id를 해싱하는 것이 가장 간단하고 확실한 방법입니다.
    }
    
    /// Equatable 프로토콜은 Hashable을 위해 필요하며, id를 비교하여 구현합니다.
    public static func == (lhs: IntegrationPage, rhs: IntegrationPage) -> Bool {
        return lhs.id == rhs.id
    }
}
