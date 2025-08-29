import Foundation
import Alamofire // HTTPMethod를 사용하기 위해 필요

// MARK: - API TargetType 프로토콜
/// API 요청에 필요한 공통 속성을 정의하는 프로토콜입니다.
protocol TargetType {
    /// API의 기본 URL입니다. (예: "http://13.124.11.3:8080")
    var baseURL: String { get }
    
    /// Base URL 뒤에 붙는 경로입니다. (예: "/api/auth/kakao")
    var path: String { get }
    
    /// HTTP 요청 메소드입니다. (예: .get, .post)
    var method: HTTPMethod { get }
}

// MARK: - EndPoint Enum
public enum EndPoint {
    
    // =================================================================================
    // MARK: - Auth (인증 관련)
    // =================================================================================
    
    /// 카카오 소셜 로그인 (oauth2). POST 요청.
    case kakaoLogin
    /// 애플 소셜 로그인 (oauth2). POST 요청. (미완료)
    case appleLogin
    /// 리프레시 토큰을 사용해 새로운 액세스 토큰을 재발급. POST 요청.
    case refreshToken
    /// 로그아웃. POST 요청.
    case logout
    
    // =================================================================================
    // MARK: - Users (사용자 정보 관련)
    // =================================================================================
    
    /// 현재 로그인된 사용자 정보 조회. GET 요청.
    case getUserInfo
    /// 사용자 알림 동의 등 수정. PATCH 요청.
    case updateUserNotifications
    /// 회원 탈퇴. DELETE 요청.
    case deleteUser
    /// 사용자의 관심사를 처음 선택(등록). POST 요청.
    case selectInterests(userId: Int)
    /// 사용자의 기존 관심사 수정. PATCH 요청.
    case updateInterests(userId: Int)
    /// 특정 사용자의 관심사 목록 조회. GET 요청.
    case getInterests(userId: Int)

    // =================================================================================
    // MARK: - Profiles (프로필 관련)
    // =================================================================================

    /// 매칭 프로필 목록 조회 (무한 스크롤 지원). GET 요청.
    case getMatchingProfiles
    /// 모든 사용자 프로필 전체 조회. GET 요청.
    case getAllProfiles
    /// 특정 사용자 ID로 프로필 조회. GET 요청.
    case getUserProfile(userId: Int)
    /// 프로필 고유 ID로 단일 프로필 조회. GET 요청.
    case getSingleProfile(id: Int)
    /// 새로운 프로필 작성. POST 요청.
    case createProfile
    /// 기존 프로필 수정. PATCH 요청.
    case updateProfile
    /// 프로필 삭제. PATCH 요청.
    case deleteProfile
    /// 프로필 이미지 모두 조회. GET 요청.
    case getAllProfileImages
    
    // =================================================================================
    // MARK: - Reports (신고 관련)
    // =================================================================================
    
    /// 특정 신고 단일 조회. GET 요청.
    case getSingleReport(id: Int)
    /// 모든 신고 조회. GET 요청.
    case getAllReports
    /// 새로운 신고 등록. POST 요청.
    case createReport
    /// 특정 신고 삭제. DELETE 요청.
    case deleteReport(id: Int)
    
    // =================================================================================
    // MARK: - Call (통화 관련)
    // =================================================================================
    
    /// 통화 요청 보내기. POST 요청.
    case requestCall
    /// 통화 수락. POST 요청.
    case acceptCall
    /// 통화 거절. POST 요청.
    case denyCall
    /// 통화 종료. POST 요청.
    case endCall
    /// 내가 보낸(발신) 통화 기록 조회. GET 요청.
    case getSentCalls(senderId: Int)
    /// 내가 받은(수신) 통화 기록 조회. GET 요청.
    case getReceivedCalls(receiverId: Int)
    
    // =================================================================================
    // MARK: - Call Reviews (통화 리뷰 관련)
    // =================================================================================
    
    /// 통화 리뷰 작성. POST 요청.
    case createCallReview
    /// 통화 리뷰 수정. PATCH 요청.
    case updateCallReview
    /// 내가 받은 평가(리뷰) 목록 조회. GET 요청.
    case getReceivedReviews
    /// 상대방이 받은 평가(리뷰) 목록 조회. GET 요청.
    case getOtherUserReviews(userId: Int)
    /// 내가 작성한 평가(리뷰) 목록 조회. GET 요청.
    case getWrittenReviews
}

// MARK: - EndPoint Extension (TargetType 준수)
extension EndPoint: TargetType {
    
    public var baseURL: String {
        // 실제 프로젝트에서는 Info.plist나 xcconfig 파일에서 URL을 관리하는 것이 좋습니다.
        return "http://13.124.11.3:8080"
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
        case .getAllProfiles: return "/api/profiles"
        case .getUserProfile(let userId): return "/api/profiles/user/\(userId)"
        case .getSingleProfile(let id): return "/api/profiles/\(id)"
        case .createProfile, .updateProfile, .deleteProfile: return "/api/profiles"
        case .getAllProfileImages: return "/api/profiles/images"
            
        // Reports
        case .getSingleReport(let id): return "/api/reports/\(id)"
        case .getAllReports: return "/api/reports"
        case .createReport: return "/api/reports"
        case .deleteReport(let id): return "/api/reports/\(id)"
            
        // Call
        case .requestCall: return "/api/calls/request"
        case .acceptCall: return "/api/calls/accept"
        case .denyCall: return "/api/calls/deny"
        case .endCall: return "/api/calls/end"
        case .getSentCalls(let senderId): return "/api/calls/sender/\(senderId)"
        case .getReceivedCalls(let receiverId): return "/api/calls/receiver/\(receiverId)"
            
        // Call Reviews
        case .createCallReview, .updateCallReview: return "/api/call-reviews"
        case .getReceivedReviews: return "/api/call-reviews/received"
        case .getOtherUserReviews(let userId): return "/api/call-reviews/other/\(userId)"
        case .getWrittenReviews: return "/api/call-review/written" // API 문서에 `call-review`로 되어 있어 그대로 반영
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .kakaoLogin, .appleLogin, .refreshToken, .logout, .selectInterests,
             .createProfile, .createReport, .requestCall, .acceptCall, .denyCall,
             .endCall, .createCallReview:
            return .post
            
        case .updateUserNotifications, .updateInterests, .updateProfile, .deleteProfile,
             .updateCallReview:
            return .patch
            
        case .deleteUser, .deleteReport:
            return .delete
            
        default:
            // 나머지 모든 케이스는 GET
            return .get
        }
    }
}
