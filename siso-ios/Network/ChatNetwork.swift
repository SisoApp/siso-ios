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
import Combine

public class ChatNetwork {
    public static let shared: ChatNetwork = .init()
    private var stomp: SwiftStomp?
    private let baseURL: String?
    private let socketURL: String?
    private let keyChain: KeyChainManager = .shared
    private var subscribedRoomId: Int? // 현재 구독중인 채팅방 ID
    
    
    
    
    private init() {
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
        
        // 소켓 중복 연결 방지
        if stomp?.isConnected == true {
            print("✅ STOMP is already connected. Skipping...")
            return
        }
        
        print("✅ connectStomp: Found AccessToken, attempting to connect...")
        print("   - Token: Bearer \(accessToken)") // ✅ 실제 토큰 확인
        let connectHeaders: [String: String] = [
            "Authorization": "Bearer \(accessToken)",
            "heart-beat": "20000,20000" //
        ]
        stomp = SwiftStomp(
            host: url,
            headers: connectHeaders
        )
        
        // stomp?.enableLogging = true
        stomp?.delegate = self
        stomp?.connect(autoReconnect: true)
    }
    
    /// 특정 채팅방 구독 메서드
    public func subscribeToRoom(roomId: Int) {
        
        
        guard let stomp = stomp, stomp.isConnected else {
            print( "❌ STOMP is not connected. Cannot subscribe to room.")
            // 2. 연결이 안되어 있으면 연결을 시도
            connectStomp()
            
            // 3. 1초 후에 구독을 다시 시도 (연결될 시간을 줌)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                print("🔁 Retrying subscription for room \(roomId)...")
                self?.subscribeToRoom(roomId: roomId)
            }
            return
        }
        
        if subscribedRoomId == roomId {
            print("Already subscribed to room \(roomId)")
            return
        }
        
        stomp.subscribe(to: "/user/queue/chat-room/\(roomId)")
        subscribedRoomId = roomId
        print("✅ Subscribe to room \(roomId)")
    }
    
    // MARK: - NEW CODE: 소켓 연결 해제
    /// STOMP WebSocket 연결 해제
    public func disconnectStomp() {
        guard let stomp = stomp, stomp.isConnected else {
            print("ℹ️ STOMP is already disconnected or not initialized.")
            return
        }
        
        stomp.disconnect()
        print("✅ STOMP Disconnected successfully.")
    }
    
    // MARK: - NEW CODE: 채팅방 구독 해제
    /// 특정 채팅방 구독 해제
    public func unsubscribeFromRoom(roomId: Int) {
        guard let stomp = stomp, stomp.isConnected else {
            print( "❌ STOMP is not connected. Cannot unsubscribe.")
            return
        }
        
        // 구독중인 방이 맞는지 확인 후 구독 해제
        if subscribedRoomId == roomId {
            let destination = "/user/queue/chat-room/\(roomId)"
            stomp.unsubscribe(from: destination)
            subscribedRoomId = nil // 구독 정보 초기화
            print("✅ Unsubscribed from room \(roomId)")
        }
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
        
        let receiptId = UUID().uuidString
        // 3. HTTP 헤더 설정
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "receipt": receiptId
        ]
        
        // 4. Alamofire를 사용한 비동기 네트워크 요청
        let task = AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
        
        // 5. 응답 데이터를 SisoResponse<[ChatMessageResponseDTO]> 타입으로 디코딩
        let response = await task.serializingDecodable(SisoResponse2<[ChatMessageResponseDTO]>.self).response
        
        
        
        // 서버로부터 받은 원본(Raw) 데이터 출력
        if let data = response.data, let rawResponseString = String(data: data, encoding: .utf8) {
            //  print("Raw Response Body:\n\(rawResponseString)")
        } else {
            print("Raw Response Body: [No Data]")
        }
        
        switch response.result {
        case .success(let sisoResponse):
            // 응답 데이터가 성공적으로 디코딩되었을 때, data 부분을 반환
            let messagesToReturn = sisoResponse.data ?? []
            
            
            
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
            throw error
        }
    }
}

extension ChatNetwork: SwiftStompDelegate {
    public func onConnect(swiftStomp : SwiftStomp, connectType : StompConnectType) {
        print("✅ STOMP Connected")
        //swiftStomp.subscribe(to: "/user/queue/")
    }
    
    /// 연결 끊김
    public func onDisconnect(swiftStomp : SwiftStomp, disconnectType : StompDisconnectType) {
        print("disconnect!!")
    }
    
    /// 문자옴
    public func onMessageReceived(swiftStomp : SwiftStomp, message : Any?, messageId : String, destination : String, headers : [String : String]) {
        debugPrint("✅ STOMP 메시지 수신 성공: \(String(describing: message))")
        
        guard let messageData = message as? String, let data = messageData.data(using: .utf8) else {
            debugPrint("❌ Failed to convert message to Data.")
            return
        }
        
        do {
            let message = try JSONDecoder().decode(ChatMessageResponseDTO.self, from: data)
            debugPrint("✅ Received message: \(message.content)")
            
            // 메시지 수신 알림 - NotificationCenter
            NotificationCenter.default.post(
                name: NSNotification.Name("newMessage"),
                object: message
            )
        } catch {
            debugPrint("❌ Failed to decode new message: \(error.localizedDescription)")
        }
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
