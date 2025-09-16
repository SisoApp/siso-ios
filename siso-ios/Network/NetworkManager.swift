import Foundation
import Alamofire
import model // MatchingProfile, CallInfoDto 등 DTO 모델이 있는 모듈

public final class NetworkManager {
    public static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Core Request Method
    // NetworkManager 클래스 내부에 추가
    private func _request(
        target: EndPoint,
        parameters: Parameters? = nil
    ) async -> DataResponse<Data, AFError> {
        
        // 1. 토큰 및 헤더 생성 (중복 제거)
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            // 실제로는 에러를 던지거나 해야 하지만, 여기서는 응답 객체를 직접 생성하여 반환
            let error = AFError.sessionInvalidated(error: NetworkError.missingAccessToken)
            return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: .failure(error))
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]
        
        let url = target.baseURL + target.path
        let encoding: ParameterEncoding = (target.method == .get) ? URLEncoding.default : JSONEncoding.default
        
        // 2. 요청/응답 로그 중앙화 (중복 제거)
        print("\n-------------------- 🚀 [Request: \(target.path)] --------------------")
        print("URL: \(url)")
        print("Method: \(target.method.rawValue)")
        print("Headers: \(headers.dictionary)")
        if let params = parameters { print("Parameters: \(params)") }
        print("----------------------------------------------------------------------\n")
        
        let dataTask = AF.request(
            url,
            method: target.method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
            .validate(statusCode: 200..<300)
            .serializingData() // 디코딩은 나중에 하므로 여기선 Data만 받음
        
        let response = await dataTask.response
        
        print("\n-------------------- ✨ [Response: \(target.path)] -------------------")
        print("URL: \(response.request?.url?.absoluteString ?? "N/A")")
        print("Status Code: \(response.response?.statusCode ?? 0)")
        
        switch response.result {
        case .success(let data):
            print("Result: ✅ Success")
            if let jsonString = String(data: data, encoding: .utf8)?.prettyJsonString {
                print("Body:\n\(jsonString)")
            } else {
                print("Body: [Non-JSON or Empty]")
            }
        case .failure(let error):
            print("Result: 🔴 Failure")
            print("Error: \(error.localizedDescription)")
            if let data = response.data, let errorBody = String(data: data, encoding: .utf8) {
                print("Error Body:\n\(errorBody)")
            }
        }
        print("----------------------------------------------------------------------\n")
        
        return response
    }

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
            .responseString(encoding: .utf8) { response in
                        print("📄 [RAW JSON RESPONSE for \(target)]")
                        switch response.result {
                        case .success(let jsonString):
                            print(jsonString)
                        case .failure(let error):
                            print("Failed to get raw string: \(error)")
                        }
                        print("------------------------------------")
                    }
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
    // NetworkManager.swift

    /// [POST] /api/calls/accept - 수신자가 통화를 수락합니다.
    public func acceptCall(callInfo: CallInfoDto) async throws -> CallResponseDto {
        
        // ✅ 1. 'acceptCall' API의 응답 구조와 '정확하게' 일치하는 임시 래퍼를 정의합니다.
        //    이 구조는 {"status": Int, "data": CallResponseDto, ...} 형태의 JSON을 처리합니다.
        struct TempAcceptCallResponseWrapper: Decodable {
            let status: Int
            let data: CallResponseDto // 'data'의 값은 단일 CallResponseDto 객체입니다.
            let errorMessage: String?
        }

        // 2. 요청에 필요한 URL, 파라미터, 헤더를 준비합니다.
        let target = EndPoint.acceptCall
        let parameters = try callInfo.toDictionary()
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw NetworkError.missingAccessToken
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        // 3. Alamofire로 네트워크 요청을 보냅니다.
        let dataTask = AF.request(
            target.baseURL + target.path,
            method: target.method,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
            .validate(statusCode: 200..<300)
            // ✅ 4. 범용 SisoResponse 대신, 위에서 정의한 '임시 래퍼'로 디코딩합니다.
            .serializingDecodable(TempAcceptCallResponseWrapper.self)

        // 5. 응답을 비동기적으로 기다립니다.
        let response = await dataTask.response

        // 6. 응답 결과를 처리합니다.
        switch response.result {
        case .success(let wrapperResponse):
            // ✅ 7. 디코딩된 래퍼 객체에서 'data' 프로퍼티만 성공적으로 추출하여 반환합니다.
            return wrapperResponse.data
            
        case .failure(let afError):
            // 디코딩 실패 또는 네트워크 오류 발생 시, 상세 로그를 남기고 에러를 던집니다.
            if let data = response.data, let body = String(data: data, encoding: .utf8) {
                print("--- 🔴 Network Error Body (acceptCall) 🔴 ---\n\(body)\n------------------------------")
            }
            print("🔴 Decoding Error (acceptCall): \(afError)")
            throw NetworkError.afError(afError)
        }
    }
    
    
    /// [POST] /api/calls/deny - 수신자가 통화를 거절합니다.
    public func denyCall(callInfo: IncomingCallPayload) async throws -> CallResponseDto {
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
    
    /// [GET] /api/calls/caller - 내가 발신한 통화 기록 목록을 조회합니다.
    // HIGHLIGHT START: 통화 기록 API 전용 래퍼 구조체 정의
    private struct TempCallHistoryResponseWrapper: Decodable {
        let status: Int
        let data: [CallHistoryItemDto]? // 'data'의 값은 CallHistoryItemDto 배열
        let errorMessage: String?
    }
    public func getCallHistoryWithCallerId() async throws -> [CallHistoryItemDto] {
        
        let target = EndPoint.getCallHistoryWithCallerId
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw NetworkError.missingAccessToken
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]
        
        let dataTask = AF.request(
            target.baseURL + target.path,
            method: target.method,
            // GET 요청이므로 parameters는 nil
            encoding: URLEncoding.default,
            headers: headers
        )
            .validate(statusCode: 200..<300)
            // HIGHLIGHT: 임시 래퍼 사용
            .serializingDecodable(TempCallHistoryResponseWrapper.self)
        
        let response = await dataTask.response
        
        switch response.result {
        case .success(let wrapperResponse):
            // data 필드가 옵셔널이므로 nil 검사
            guard let callHistory = wrapperResponse.data else {
                throw NetworkError.serverError(message: wrapperResponse.errorMessage ?? "통화 기록 데이터가 비어있습니다.")
            }
            return callHistory
            
        case .failure(let afError):
            // 에러 로그는 이미 기존의 코드가 출력하고 있습니다.
            throw NetworkError.afError(afError)
        }
    }

    /// [GET] /api/calls/receiver - 내가 수신한 통화 기록 목록을 조회합니다.
    public func getCallHistoryWithReceiverId() async throws -> [CallHistoryItemDto] {
        
        let target = EndPoint.getCallHistoryWithReceiverId
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw NetworkError.missingAccessToken
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]
        
        let dataTask = AF.request(
            target.baseURL + target.path,
            method: target.method,
            encoding: URLEncoding.default,
            headers: headers
        )
            .validate(statusCode: 200..<300)
            .serializingDecodable(TempCallHistoryResponseWrapper.self)
        
        let response = await dataTask.response
        
        switch response.result {
        case .success(let wrapperResponse):
            guard let callHistory = wrapperResponse.data else {
                throw NetworkError.serverError(message: wrapperResponse.errorMessage ?? "통화 기록 데이터가 비어있습니다.")
            }
            return callHistory
            
        case .failure(let afError):
            throw NetworkError.afError(afError)
        }
    }
    
    // NetworkManager.swift 클래스 내부에 아래 함수를 추가합니다.

    /// [POST] /api/reports - 사용자를 신고합니다.
    ///
    /// 서버 컨트롤러의 `@RequestBody`는 JSON을 의미하므로 Content-Type은 "application/json"으로 전송합니다.
    /// - Parameter dto: 신고 정보를 담고 있는 `ReportRequestDto` 객체
    /// - Returns: 신고 처리 결과를 담은 `ReportResponseDto`
    /// - Throws: `NetworkError` - 네트워크 또는 디코딩 실패 시
    public func addReport(dto: ReportRequestDto) async throws -> ReportResponseDto {
        
        let target = EndPoint.addReport
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw NetworkError.missingAccessToken
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        // Encodable DTO를 Alamofire가 사용할 수 있는 파라미터로 변환합니다.
        let parameters = try dto.toDictionary()
        
        let dataTask = AF.request(
            target.baseURL + target.path,
            method: target.method,
            parameters: parameters,
            encoding: JSONEncoding.default, // @RequestBody는 JSONEncoding
            headers: headers
        )
            .validate(statusCode: 200..<300) // 201 Created 포함
            .serializingDecodable(ReportResponseDto.self) // SisoResponse 래퍼 없이 바로 디코딩
        
        let response = await dataTask.response
        
        switch response.result {
        case .success(let reportResponse):
            return reportResponse
        case .failure(let afError):
            if let data = response.data, let body = String(data: data, encoding: .utf8) {
                print("--- 🔴 Network Error Body (addReport) 🔴 ---\n\(body)\n------------------------------")
            }
            throw NetworkError.afError(afError)
        }
    }
    /// [POST] /api/fcm/token - 서버에 FCM 토큰을 등록합니다.
    ///
    /// 성공 시 특정 객체를 반환하지 않고, 성공 여부만 확인합니다.
    /// - Parameter dto: 사용자 ID와 FCM 토큰을 담은 `FcmTokenRequestDto`
    /// - Throws: `NetworkError` - 네트워크 요청 실패 시
    public func registerFcmToken(dto: FcmTokenRequestDto) async throws {
        
        let target = EndPoint.registerFcmToken
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw NetworkError.missingAccessToken
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        // Encodable DTO를 Alamofire 파라미터로 변환
        let parameters = try dto.toDictionary()
        
        let dataTask = AF.request(
            target.baseURL + target.path,
            method: target.method,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
            .validate(statusCode: 200..<300)
            // HIGHLIGHT: 응답 본문이 단순 문자열이므로 .serializingString() 사용
            .serializingString()
        
        let response = await dataTask.response
        
        switch response.result {
        case .success(let responseString):
            // 성공 시, 서버가 보낸 문자열을 로그로 출력하고 아무것도 반환하지 않음 (Void)
            print("✅ FCM Token registered successfully: \(responseString)")
            return
            
        case .failure(let afError):
            // 실패 시 에러 처리
            if let data = response.data, let body = String(data: data, encoding: .utf8) {
                print("--- 🔴 Network Error Body (registerFcmToken) 🔴 ---\n\(body)\n------------------------------")
            }
            throw NetworkError.afError(afError)
        }
    }
    
    /// 서버 응답의 `data` 필드에 포함된 알림 DTO 배열을 반환합니다.
    /// - Returns: 알림 DTO 배열 `[NotificationResponseDto]`
    /// - Throws: `NetworkError` - 네트워크 통신 또는 디코딩 실패 시
    // 알림 API 전용 래퍼 구조체 (NetworkManager 내부에 private으로 선언)
    // ✅ 수정된 TempNotificationResponseWrapper 구조체
    struct TempNotificationResponseWrapper: Decodable {
        let status: Int
        let data: [NotificationResponseDto]? // data는 배열이므로 그대로 둡니다.
        let errorMessage: String? // errorMessage는 null일 수 있으므로 옵셔널(String?)로 선언합니다.
    }


    /// [GET] /api/notifications - 현재 사용자의 모든 알림 목록을 조회합니다.
    public func getNotifications() async throws -> [NotificationResponseDto] {
        
        // 1. 중앙 헬퍼 함수로 요청을 보내고 응답을 받음
        let response = await _request(target: .getNotification)
        
        // 2. 받은 응답을 처리
        switch response.result {
        case .success(let data):
            do {
                // 3. 필요한 타입(TempNotificationResponseWrapper)으로 직접 디코딩
                let wrapper = try JSONDecoder().decode(TempNotificationResponseWrapper.self, from: data)
                return wrapper.data ?? []
            } catch {
                // 디코딩 실패 시 에러 처리
                throw NetworkError.decodingError(error)
            }
            
        case .failure(let afError):
            // 네트워크 실패 시 에러 처리
            throw NetworkError.afError(afError)
        }
    }

    /// [PATCH] /api/notifications/{notificationId}/read - 특정 알림을 읽음 상태로 변경합니다.
    ///
    /// 성공 시 반환되는 데이터가 없으므로, 함수의 반환 타입은 Void입니다.
    /// - Parameter notificationId: 읽음 처리할 알림의 ID
    /// - Throws: `NetworkError` - 네트워크 요청 실패 시
    public func markNotificationAsRead(notificationId: Int) async throws {
        
        // 범용 `request` 함수는 성공 시 data 필드를 기대하는데,
        // 이 API의 data는 null 또는 비어있을 수 있어 직접 처리하는 것이 더 안전합니다.
        
        let target = EndPoint.markNotificationAsRead(notificationId: notificationId)
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw NetworkError.missingAccessToken
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
            // PATCH 요청이지만 Body가 없으므로 Content-Type은 불필요
        ]
        
        let dataTask = AF.request(
            target.baseURL + target.path,
            method: target.method,
            // Body가 없으므로 parameters는 nil
            headers: headers
        )
            .validate(statusCode: 200..<300)
            .serializingData() // 응답 본문이 없거나 무시해도 되므로 .serializingData() 사용
        
        let response = await dataTask.response
        
        switch response.result {
        case .success:
            // HTTP 상태 코드가 200-299 범위 안에 들어오면 성공으로 간주하고 함수를 종료합니다.
            print("✅ Notification (id: \(notificationId)) marked as read successfully.")
            return
            
        case .failure(let afError):
            // 실패 시 에러 처리
            if let data = response.data, let body = String(data: data, encoding: .utf8) {
                print("--- 🔴 Network Error Body (markNotificationAsRead) 🔴 ---\n\(body)\n------------------------------")
            }
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
// JSON 문자열을 예쁘게 출력하기 위한 Helper
extension String {
    var prettyJsonString: String? {
        guard let data = self.data(using: .utf8) else { return nil }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
              let prettyString = String(data: prettyData, encoding: .utf8) else { return nil }
        return prettyString
    }
}
