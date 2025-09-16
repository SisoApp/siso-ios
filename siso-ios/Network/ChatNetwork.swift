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
        guard let accessToken = keyChain.get(for: "accessToken") else { return }
        stomp = SwiftStomp(host: url, headers: ["Authorization": "Bearer \(accessToken)"])
        stomp?.delegate = self
        stomp?.connect()
    }
    
    /// ** MARK:   메시지 전송 ( 실시간 )
    public func messageSend(chatRoomId: Int, content: String) {
        guard let stomp = stomp else { return }
        
        let body: [String: Any] = [
            "chatRoomId": chatRoomId,
            "content": content
        ]
        
        if let data = try? JSONSerialization.data(withJSONObject: body),
           let jsonString = String(data: data, encoding: .utf8) {
            stomp.send(body: jsonString, to: "/app/chat.sendMessage")
        }
    }
}


extension ChatNetwork: SwiftStompDelegate {
    public func onConnect(swiftStomp : SwiftStomp, connectType : StompConnectType) {
        print("✅ STOMP Connected")
        swiftStomp.subscribe(to: "/user/queue/messages")
    }

    public func onDisconnect(swiftStomp : SwiftStomp, disconnectType : StompDisconnectType) {
        print("disconnect!!")
    }

    public func onMessageReceived(swiftStomp : SwiftStomp, message : Any?, messageId : String, destination : String, headers : [String : String]) {
        
    }

    public func onReceipt(swiftStomp : SwiftStomp, receiptId : String) {
        
    }

    public func onError(swiftStomp : SwiftStomp, briefDescription : String, fullDescription : String?, receiptId : String?, type : StompErrorType) {
        
    }
}
