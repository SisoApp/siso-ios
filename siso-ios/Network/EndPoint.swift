import Foundation
import Alamofire // HTTPMethod를 사용하기 위해 필요

// MARK: - API TargetType 프로토콜

// MARK: - EndPoint Enum

public enum EndPoint {
    // MARK: - Auth (인증 관련)
    case kakaoLogin
    case appleLogin
    case refreshToken
    case logout
    
    // MARK: - Users (사용자 정보 관련)
    case getUserInfo
    case updateUserNotifications
    case deleteUser
    case selectInterests(userId: Int)
    case updateInterests(userId: Int)
    case getInterests(userId: Int)
    
    // MARK: - Profiles (프로필 관련)
    case getMatchingProfiles
    case getUserProfile(userId: Int)
    
    // MARK: - Reports (신고 관련)
    case createReport
    
    // MARK: - Call (통화 관련)
    case requestCall
    case acceptCall
    case denyCall
    case endCall
    case getCallHistoryWithCallerId   // 내가 건 통화 기록
    case getCallHistoryWithReceiverId // 내가 받은 통화 기록
    case addReport
}

// MARK: - EndPoint Extension (TargetType 준수)

extension EndPoint: TargetType {
    
    /// Info.plist에서 "SERVER_URL" 값을 가져와 사용합니다.
    public var baseURL: String {
        guard let serverURL = Bundle.main.infoDictionary?["SERVER_URL"] as? String else {
            fatalError("🚨 SERVER_URL is not set in Info.plist")
        }
        return serverURL
    }
    
    public var path: String {
        switch self {
            // Auth
        case .kakaoLogin: return "/api/auth/kakao"
        case .appleLogin: return "/api/auth/apple"
        case .refreshToken: return "/api/auth/refresh"
        case .logout: return "/api/users/logout"
            
            // Users
        case .getUserInfo: return "/api/users/info"
        case .updateUserNotifications: return "/api/users/notification"
        case .deleteUser: return "/api/users/delete"
        case .selectInterests(let userId): return "/api/users/\(userId)/interests/select"
        case .updateInterests(let userId): return "/api/users/\(userId)/interests/update"
        case .getInterests(let userId): return "/api/users/\(userId)/interests/list"
            
            // Profiles
        case .getMatchingProfiles: return "/api/filter/matching"
        case .getUserProfile(let userId): return "/api/profiles/user/\(userId)"
            
            // Reports
        case .createReport: return "/api/reports"
            
            // Call
        case .requestCall: return "/api/calls/request"
        case .acceptCall: return "/api/calls/accept"
        case .denyCall: return "/api/calls/deny"
        case .endCall: return "/api/calls/end"
        case .getCallHistoryWithCallerId: return "/api/calls/caller"
        case .getCallHistoryWithReceiverId: return "/api/calls/receiver"
        case .addReport: return "/api/reports"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
            // POST
        case .kakaoLogin, .appleLogin, .refreshToken, .logout, .selectInterests,
                .createReport, .requestCall, .acceptCall, .denyCall, .endCall, .addReport:
            return .post
            
            // PATCH
        case .updateUserNotifications, .updateInterests:
            return .patch
            
            // DELETE
        case .deleteUser:
            return .delete
            
            // GET
        default:
            return .get
        }
    }
}
