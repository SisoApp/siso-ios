//
//  ChatNetwork.swift
//  network
//
//  Created by 김용해 on 9/3/25.
//

import Foundation
import Alamofire
import model
import SwiftStomp

public class ChatNetwork {
    private var stomp: SwiftStomp?
    private let baseURL: String?
    private let socketURL: String?
    private let keyChain: KeyChainManager = .shared
    public init() {
        baseURL = Bundle.main.infoDictionary?["SERVER_URL"] as? String
        socketURL = Bundle.main.infoDictionary?["SOKET_URL"] as? String
        connectStomp()
    }
    
    /// ** MARK:   사용자의 채팅방 조회
    public func readAll() async throws -> [ChatRoomResponseDTO] {
        guard let baseURL = baseURL else { throw AFError.invalidURL(url: "base URL is Not Found") }
        let urlString = "\(baseURL)/api/chats/rooms"
        
        guard let url = URL(string: urlString) else {
            throw AFError.invalidURL(url: urlString)
        }
        
        guard let accessToken = keyChain.get(for: "accessToken") else {
            print("accessToken 이 없습니다")
            return []
        }
        print("accessToken : \(accessToken)")
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        let task = AF.request(url,
                              method: .get,
                              encoding: JSONEncoding.default,
                              headers: headers
        )
            .validate(statusCode: 200..<300)
        
        let responseData = await task.serializingData().response
        
        if let data = responseData.data {
            let decodedData =  try JSONDecoder().decode(ChatDTO.self, from: data)
            return decodedData.data ?? []
        }
        
        return []
    }
    
    
    /// STOMP WebSocket 연결
    public func connectStomp() {
        guard let urlString = socketURL else { return }
        guard let url = URL(string: "\(urlString)/ws-stomp/websocket") else { return }
        guard let accessToken = keyChain.get(for: "accessToken") else {
            print("❌ connectStomp FAILED: AccessToken not found in Keychain.")
            return
        }
        
        print("✅ connectStomp: Found AccessToken, attempting to connect...")
        print("   - Token: Bearer \(accessToken)") // ✅ 실제 토큰 확인

        stomp = SwiftStomp(
            host: url,
            headers: [
                "Authorization": "Bearer \(accessToken)" // ✅ 여기 문자열 보간
            ]
        )
        stomp?.delegate = self
        stomp?.connect()
    }
    
    public func messageSend(chatRoomId: Int, content: String) {
        // 1. STOMP 연결 상태 확인
        guard let stomp = stomp, stomp.isConnected else {
            print("❌ STOMP is not connected. Cannot send message.")
            return
        }

        // 2. 메시지 본문(Body) 생성
        let body: [String: Any] = [
            "chatRoomId": chatRoomId,
            "content": content
        ]

        // 3. JSON 문자열로 변환
        guard let data = try? JSONSerialization.data(withJSONObject: body),
              let jsonString = String(data: data, encoding: .utf8) else {
            print("❌ Failed to serialize message body to JSON string.")
            return
        }
        
        // 4. 메시지 전송 시 content-type 헤더 추가 (★★★★★ 중요 ★★★★★)
        let headers = ["content-type": "application/json"]
        stomp.send(body: jsonString, to: "/app/chat.sendMessage", headers: headers)

        print("🙈 Message sent successfully!")
        print("  - Destination: /app/chat.sendMessage")
        print("  - Headers: \(headers)")
        print("  - Body: \(jsonString)")
    }
    
    /// ** MARK:   특정 채팅방의 모든 메시지 조회
    /// - Parameter chatRoomId: 메시지를 조회할 채팅방의 ID
    /// - Returns: 해당 채팅방의 메시지 배열
    public func getMessages(chatRoomId: Int) async throws -> [ChatMessageResponseDTO] {
        // 1. URL 구성
        guard let baseURL = baseURL else {
            throw AFError.invalidURL(url: "Base URL is not found")
        }
        let urlString = "\(baseURL)/api/chats/rooms/\(chatRoomId)/messages"
        
        guard let url = URL(string: urlString) else {
            throw AFError.invalidURL(url: urlString)
        }
        
        // 2. AccessToken 가져오기
        guard let accessToken = keyChain.get(for: "accessToken") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        // 3. HTTP 헤더 설정
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        // ======================== 🚀 요청 정보 로그 ========================
        print("\n/-------------------- 🚀 API Request --------------------/")
        print("URL: GET \(url.absoluteString)")
        print("Headers: \(headers)")
        print("/---------------------------------------------------------/\n")
        // ===============================================================
        
        // 4. Alamofire를 사용한 비동기 네트워크 요청
        let task = AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
        
        // 5. 응답 데이터를 SisoResponse<[ChatMessageResponseDTO]> 타입으로 디코딩
        let response = await task.serializingDecodable(SisoResponse2<[ChatMessageResponseDTO]>.self).response
        
        // ======================== 📥 응답 정보 로그 ========================
        print("\n/-------------------- 📥 API Response --------------------/")
        print("Status Code: \(response.response?.statusCode ?? 0)")
        
        // 서버로부터 받은 원본(Raw) 데이터 출력
        if let data = response.data, let rawResponseString = String(data: data, encoding: .utf8) {
            print("Raw Response Body:\n\(rawResponseString)")
        } else {
            print("Raw Response Body: [No Data]")
        }
        print("/---------------------------------------------------------/\n")
        // ===============================================================
        
        switch response.result {
        case .success(let sisoResponse):
            // 응답 데이터가 성공적으로 디코딩되었을 때, data 부분을 반환
            let messagesToReturn = sisoResponse.data ?? []
            
            // ==================== ✅ 반환값 상세 로그 ====================
            print("\n/-------------------- ✅ Return Value --------------------/")
            print("Decoding Succeeded. Preparing to return \(messagesToReturn.count) message(s).")
            
            // dump()를 사용하면 구조체의 내용을 더 자세하고 보기 좋게 출력해줍니다.
            dump(messagesToReturn)
            
            print("/---------------------------------------------------------/\n")
            // ===============================================================
            
            return messagesToReturn
            
        case .failure(let error):
            // ==================== ❌ 에러 상세 로그 =====================
            print("\n/-------------------- ❌ Error Details --------------------/")
            print("Error Type: \(error)")
            if let underlyingError = error.underlyingError {
                print("Underlying Error: \(underlyingError)")
            }
            
            // 에러 응답 본문을 확인하여 서버가 보낸 에러 메시지를 파싱할 수도 있습니다.
            if let data = response.data, let errorResponse = String(data: data, encoding: .utf8) {
                print("Server Error Body: \(errorResponse)")
            }
            print("/---------------------------------------------------------/\n")
            // ===============================================================
            
            throw error
        }
    }
}

extension ChatNetwork: SwiftStompDelegate {
    public func onConnect(swiftStomp : SwiftStomp, connectType : StompConnectType) {
        print("✅ STOMP Connected")
        swiftStomp.subscribe(to: "/user/queue/messages")
    }
    
/// 연결 끊김
    public func onDisconnect(swiftStomp : SwiftStomp, disconnectType : StompDisconnectType) {
        print("disconnect!!")
    }
/// 문자옴
    public func onMessageReceived(swiftStomp : SwiftStomp, message : Any?, messageId : String, destination : String, headers : [String : String]) {
        // 문자가 오면 할 작동 적기 ㅇㅇ
    }
/// 서버로 문자가 도달했음
    public func onReceipt(swiftStomp : SwiftStomp, receiptId : String) {
        print("🧾 Receipt received for id: \(receiptId)")
    }

    public func onError(swiftStomp : SwiftStomp, briefDescription : String, fullDescription : String?, receiptId : String?, type : StompErrorType) {
        print("💥 STOMP Error: \(briefDescription)")
           if let desc = fullDescription {
               print("  - Details: \(desc)")
           }
    }
}
