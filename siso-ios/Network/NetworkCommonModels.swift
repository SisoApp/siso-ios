import Foundation
import Alamofire

// MARK: - API 응답 및 에러 정의

/// API 요청에 필요한 공통 속성을 정의하는 프로토콜입니다.
protocol TargetType {
    /// API의 기본 URL입니다.
    var baseURL: String { get }
    
    /// Base URL 뒤에 붙는 경로입니다.
    var path: String { get }
    
    /// HTTP 요청 메소드입니다.
    var method: HTTPMethod { get }
}

// AFTER (수정된 코드) ✅
public struct SisoResponse<T: Decodable>: Decodable {
   public let success: Bool
   public let data: T?
   public let errorMessage: String?
}
/// 네트워크 레이어에서 발생하는 커스텀 에러 정의
public enum NetworkError: Error, LocalizedError {
    case missingAccessToken
    case serverError(message: String)
    case afError(AFError)
    case decodingError(Error) // ✅ 디코딩 에러를 담을 케이스 추가
    case unexpectedEmptyData
    
    public var errorDescription: String? {
        switch self {
        case .missingAccessToken:
            return "인증 토큰이 없습니다. 다시 로그인해주세요."
        case .serverError(let message):
            return message
        case .afError(let afError):
            // AFError의 다양한 내부 오류를 사용자에게 더 친절하게 보여줄 수 있습니다.
            if afError.isSessionTaskError {
                return "네트워크 연결을 확인해주세요."
            }
            return afError.localizedDescription
        case .unexpectedEmptyData:
                   return "서버로부터 예상치 못한 빈 데이터를 받았습니다."
        case .decodingError(let error):
            return "데이터를解析하는 데 실패했습니다."
        }
    }
}

/// 서버 응답이 특별한 데이터를 포함하지 않을 때 사용할 모델
/// 예: { "success": true, "data": { "message": "회원 탈퇴가 완료되었습니다." } }
public struct SuccessResponse: Decodable {
    let message: String?
}

// MARK: - API Error Definition
enum ApiError: Error, LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int, message: String?)
    case decodingError(Error)
    case unexpectedResponse
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .requestFailed(let statusCode, let message):
            return message ?? "오류가 발생했습니다. (코드: \(statusCode))"
        case .decodingError:
            return "데이터를 처리하는데 실패했습니다."
        case .unexpectedResponse:
            return "서버로부터 예기치 않은 응답을 받았습니다."
        case .networkError(let error):
            return "네트워크 연결을 확인해주세요. (\(error.localizedDescription))"
        }
    }
}
