import Foundation
import Alamofire
import model // MatchingProfile, CallInfoDto 등 DTO 모델이 있는 모듈

public final class NetworkManager {
    public static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Core Request Method
    
    /// 모든 API 요청을 처리하는 제네릭 private 메서드
    private func request<T: Decodable>(
        target: EndPoint,
        parameters: Parameters? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw NetworkError.missingAccessToken
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]
        
        // GET 요청은 URLEncoding, 그 외에는 JSONEncoding 사용
        let encoding: ParameterEncoding = (target.method == .get) ? URLEncoding.default : JSONEncoding.default
        
        let dataTask = AF.request(
            target.baseURL + target.path,
            method: target.method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        .cURLDescription { print($0) }
        .validate(statusCode: 200..<300)
        .serializingDecodable(SisoResponse<T>.self)
        
        let response = await dataTask.response
        
        switch response.result {
        case .success(let sisoResponse):
            if sisoResponse.success, let data = sisoResponse.data {
                return data
            } else {
                let errorMessage = sisoResponse.errorMessage ?? "알 수 없는 서버 오류입니다."
                throw NetworkError.serverError(message: errorMessage)
            }
        case .failure(let afError):
            if let data = response.data, let body = String(data: data, encoding: .utf8) {
                print("--- 🔴 Network Error Body 🔴 ---\n\(body)\n------------------------------")
            }
            throw NetworkError.afError(afError)
        }
    }
    
    // MARK: - API Public Methods
    
    /// [GET] /api/filter/matching - 매칭 프로필 목록 조회
    public func getMatchingProfiles(count: Int = 5) async throws -> [MatchingProfile] {
        let parameters: [String: Any] = ["count": count]
        return try await request(target: .getMatchingProfiles, parameters: parameters, responseType: [MatchingProfile].self)
    }
    
    /// [POST] /api/calls/request - 통화 요청
    public func requestCall(receiverId: Int) async throws -> CallInfoDto {
        let parameters: [String: Any] = ["receiverId": receiverId]
        
        // ✅ 수정된 코드: responseType을 배열 [CallInfoDto].self로 변경
        let callInfoArray = try await request(
            target: .requestCall,
            parameters: parameters,
            responseType: [CallInfoDto].self // ✨ 핵심: 배열 타입으로 디코딩
        )
        
        // 디코딩된 배열에서 첫 번째 요소를 안전하게 추출
        guard let callInfo = callInfoArray.first else {
            // NetworkError에 .unexpectedEmptyData 케이스를 추가하면 더 좋습니다.
            throw NetworkError.serverError(message: "서버로부터 유효한 통화 정보를 받지 못했습니다.")
        }
        
        return callInfo
    }
    /// [POST] /api/calls/accept - 수신자가 통화를 수락합니다.
        /// - Parameter callInfo: 수신한 통화 정보 객체 (`IncommingCall` 또는 `CallInfoDto`)
        /// - Returns: 통화 수락 결과 정보 (`CallResponseDto`)
        /// - Throws: NetworkError
        public func acceptCall(callInfo: CallInfoDto) async throws -> CallResponseDto {
            
            // 1. Encodable 모델을 [String: Any] 타입의 파라미터로 변환합니다.
            let parameters = try callInfo.toDictionary()
            
            // 2. 제네릭 request 함수를 호출합니다.
            // ✨ 핵심: 이번에는 응답 'data'가 단일 객체이므로,
            // responseType을 `CallResponseDto.self`로 지정합니다.
            return try await request(
                target: .acceptCall,
                parameters: parameters,
                responseType: CallResponseDto.self
            )
        }
  
}
fileprivate extension Encodable {
    /// Encodable 객체를 Alamofire의 Parameters 타입인 `[String: Any]`로 변환합니다.
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        return dictionary
    }
}
