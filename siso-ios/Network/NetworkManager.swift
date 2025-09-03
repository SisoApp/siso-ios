import Foundation
import Alamofire
import model // MatchingProfile, CallInfoDto 등 DTO 모델이 있는 모듈

public final class NetworkManager {
    public static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Core Request Method
    
    /// 모든 API 요청을 처리하는 제네릭 private 메서드
    public func request<T: Decodable>(
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
        
        // 이 엔드포인트는 SisoResponse 래퍼 없이 직접 배열을 반환하는 것으로 보입니다.
        // 따라서 `request` 제네릭 메서드를 사용하는 대신, 별도로 처리해야 합니다.
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw NetworkError.missingAccessToken
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]
        
        let target = EndPoint.getMatchingProfiles
        
        let dataTask = AF.request(
            target.baseURL + target.path,
            method: target.method,
            parameters: parameters,
            encoding: URLEncoding.default, // GET 요청
            headers: headers
        )
            .validate(statusCode: 200..<300)
            .serializingDecodable([MatchingProfile].self) // ✨
        
        let response = await dataTask.response
        
        switch response.result {
        case .success(let profiles):
            return profiles // 직접 디코딩된 프로필 배열을 반환
        case .failure(let afError):
            if let data = response.data, let body = String(data: data, encoding: .utf8) {
                print("--- 🔴 Network Error Body (getMatchingProfiles) 🔴 ---\n\(body)\n------------------------------")
            }
            throw NetworkError.afError(afError)
        }
    }
    
    /// [POST] /api/calls/request - 통화 요청
    public func requestCall(receiverId: Int) async throws -> CallInfoDto {
        let parameters: [String: Any] = ["receiverId": receiverId]
        
        // 이 API는 응답 구조가 표준 SisoResponse와 다르므로 직접 처리합니다.
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw NetworkError.missingAccessToken
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]
        
        let target = EndPoint.requestCall
        
        // ✅ 1. 서버의 실제 응답 JSON 구조와 '정확하게' 일치하는 임시 구조체를 정의합니다.
        struct TempCallRequestResponse: Decodable {
            let status: Int
            let data: CallInfoDto // 'data' 필드의 값은 CallInfoDto 객체입니다.
            let errorMessage: String?
        }
        
        let dataTask = AF.request(
            target.baseURL + target.path,
            method: target.method,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
            .validate(statusCode: 200..<300)
            .serializingDecodable(TempCallRequestResponse.self)
        
        let response = await dataTask.response
        
        switch response.result {
        case .success(let tempResponse):
            // ✅ 3. 디코딩이 성공하면, 래퍼 객체(tempResponse)에서 'data' 프로퍼티만 꺼내서 반환합니다.
            //    이렇게 하면 이 함수의 최종 반환 타입은 'CallInfoDto'가 됩니다.
            return tempResponse.data
        case .failure(let afError):
            // 디코딩 실패 시 이쪽으로 빠집니다. (현재 상황)
            if let data = response.data, let body = String(data: data, encoding: .utf8) {
                print("--- 🔴 Network Error Body (requestCall) 🔴 ---\n\(body)\n------------------------------")
            }
            // 디코딩 에러의 구체적인 원인을 확인하려면 afError를 출력해보는 것이 좋습니다.
            print("🔴 Decoding Error: \(afError)")
            throw NetworkError.afError(afError)
        }
    }
    /// [POST] /api/calls/accept - 수신자가 통화를 수락합니다.
    /// - Parameter callInfo: 수신한 통화 정보 객체 (`IncommingCall` 또는 `CallInfoDto`)
    /// - Returns: 통화 수락 결과 정보 (`CallResponseDto`)
    /// - Throws: NetworkError
    /// [POST] /api/calls/accept - 수신자가 통화를 수락합니다.
    public func acceptCall(callInfo: CallInfoDto) async throws -> CallResponseDto {
        
        // 1. Encodable 모델을 [String: Any] 타입의 파라미터로 변환합니다.
        let parameters = try callInfo.toDictionary()
        
        // ✅ 2. 제네릭 request 함수를 호출합니다.
        //    API 명세에 따라, 응답의 'data'는 배열이므로,
        //    responseType을 `[CallResponseDto].self`로 지정합니다.
        let responseArray = try await request(
            target: .acceptCall,
            parameters: parameters,
            responseType: [CallResponseDto].self // 👈 여기가 핵심 수정 사항!
        )
        
        // ✅ 3. 디코딩된 배열에서 첫 번째 요소를 안전하게 추출합니다.
        guard let response = responseArray.first else {
            // 서버가 data 배열을 비워서 보내는 예외적인 경우에 대한 방어 코드
            throw NetworkError.serverError(message: "서버로부터 유효한 통화 수락 정보를 받지 못했습니다.")
        }
        
        // ✅ 4. 추출한 단일 CallResponseDto 객체를 반환합니다.
        return response
    }
    
    
    /// [POST] /api/calls/deny - 수신자가 통화를 거절합니다.
    public func denyCall(callInfo: CallInfoDto) async throws -> CallResponseDto {
        let parameters = try callInfo.toDictionary()
        
        let responseArray = try await request(
            target: .denyCall, // 👈 EndPoint에 .denyCall 추가 필요
            parameters: parameters,
            responseType: [CallResponseDto].self
        )
        
        guard let response = responseArray.first else {
            throw NetworkError.serverError(message: "서버로부터 통화 거절 정보를 받지 못했습니다.")
        }
        return response
    }
    
    /// [POST] /api/calls/end - 통화를 종료합니다.
    public func endCall(callInfo: CallInfoDto, continueRelationship: Bool) async throws -> CallResponseDto {
        
        struct TempEndCallResponseWrapper: Decodable {
            let status: Int
            let data: CallResponseDto // 'data'의 값은 단일 CallResponseDto 객체
            let errorMessage: String?
        }
        // 1. URL, 파라미터, 헤더 준비 (기존과 동일)
        let target = EndPoint.endCall
        var urlComponents = URLComponents(string: target.baseURL + target.path)!
        urlComponents.queryItems = [URLQueryItem(name: "continueRelationship", value: String(continueRelationship))]
        let urlWithQuery = try urlComponents.asURL()
        
        let bodyParameters = try callInfo.toDictionary()
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw NetworkError.missingAccessToken
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        // 2. Alamofire 요청
        let dataTask = AF.request(
            urlWithQuery,
            method: .post,
            parameters: bodyParameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
            .cURLDescription { print($0) }
            .validate(statusCode: 200..<300)
        // HIGHLIGHT: 위에서 정의한 임시 래퍼 구조체로 디코딩하도록 변경
            .serializingDecodable(TempEndCallResponseWrapper.self)
        
        let response = await dataTask.response
        
        switch response.result {
        case .success(let wrapperResponse):
            // HIGHLIGHT: 디코딩된 래퍼 객체에서 'data' 프로퍼티만 추출하여 반환
            print("\n✅ END CALL SUCCEEDED with continueRelationship: \(continueRelationship)\n")
            print(wrapperResponse.data)
            return wrapperResponse.data
            
        case .failure(let afError):
            if let data = response.data, let body = String(data: data, encoding: .utf8) {
                print("--- 🔴 Network Error Body (endCall) 🔴 ---\n\(body)\n------------------------------")
            }
            print("🔴 Decoding Error (endCall): \(afError)")
            throw NetworkError.afError(afError)
        }
    }
}

public extension Encodable {
    /// Encodable 객체를 Alamofire의 Parameters 타입인 `[String: Any]`로 변환합니다.
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        return dictionary
    }
}
