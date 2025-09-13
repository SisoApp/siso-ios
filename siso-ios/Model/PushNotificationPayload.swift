// In 'model' module

import Foundation

/// 푸시 알림을 통해 수신되는 통화 요청 데이터 모델입니다.
/// 발신자 정보와 Agora 접속 정보를 포함합니다.
public struct IncomingCallPayload: Decodable, Equatable, Encodable {
   
    // 푸시 타입
    public let type: String
    
    // 통화 자체 정보
    public let callId: Int
    
    // Agora 접속 정보
    public let agoraChannel: String
    public let agoraToken: String
    
    // 발신자 정보 (UI 표시용)
    public let callerId: Int
    public let callerName: String
    public let callerImage: String
    
    // CodingKeys는 서버 JSON과 일치하도록 설정
    enum CodingKeys: String, CodingKey {
        case type, callId, agoraChannel, agoraToken, callerId, callerName, callerImage
    }
    public init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           
           // String 타입 프로퍼티들은 그대로 디코딩합니다.
           self.type = try container.decode(String.self, forKey: .type)
           self.agoraChannel = try container.decode(String.self, forKey: .agoraChannel)
           self.agoraToken = try container.decode(String.self, forKey: .agoraToken)
           self.callerName = try container.decode(String.self, forKey: .callerName)
           self.callerImage = try container.decode(String.self, forKey: .callerImage)
           
           // --- callId 처리 ---
           // 1. 먼저 Int로 디코딩을 시도합니다.
           do {
               self.callId = try container.decode(Int.self, forKey: .callId)
           } catch {
               // 2. Int 디코딩이 실패하면(typeMismatch 등), String으로 다시 시도합니다.
               let callIdString = try container.decode(String.self, forKey: .callId)
               // 3. String을 Int로 변환합니다. 변환조차 실패하면 디코딩 에러를 발생시킵니다.
               guard let callIdInt = Int(callIdString) else {
                   throw DecodingError.dataCorruptedError(forKey: .callId, in: container, debugDescription: "callId를 Int로 변환할 수 없습니다: \(callIdString)")
               }
               self.callId = callIdInt
           }
           
           // --- callerId 처리 (callId와 동일한 로직) ---
           do {
               self.callerId = try container.decode(Int.self, forKey: .callerId)
           } catch {
               let callerIdString = try container.decode(String.self, forKey: .callerId)
               guard let callerIdInt = Int(callerIdString) else {
                   throw DecodingError.dataCorruptedError(forKey: .callerId, in: container, debugDescription: "callerId를 Int로 변환할 수 없습니다: \(callerIdString)")
               }
               self.callerId = callerIdInt
           }
       }
    
}
public extension IncomingCallPayload {
    // 샘플 데이터나 테스트 코드에서 객체를 직접 생성할 때 사용할 수 있도록 public init을 여기에 둡니다.
    init(type: String, callId: Int, agoraChannel: String, agoraToken: String, callerId: Int, callerName: String, callerImage: String) {
            self.type = type
            self.callId = callId
            self.agoraChannel = agoraChannel
            self.agoraToken = agoraToken
            self.callerId = callerId
            self.callerName = callerName
            self.callerImage = callerImage
        }
    /// SwiftUI 프리뷰, 테스트 등에서 사용할 수 있는 정적 샘플 데이터입니다.
    static var sample: IncomingCallPayload {
        return IncomingCallPayload(
            type: "INCOMING_CALL",
            callId: 12345,
            agoraChannel: "voice_chat_channel_siso_sample",
            agoraToken: "007eJgIk4GfInN7E5aZ7f7b...<아고라 토큰은 매우 길기 때문에 임의의 값으로 대체>...AgAAAAAYGADs/gIA", // 실제 토큰이 아닌 예시 값입니다.
            callerId: 9876,
            callerName: "김철수",
            // 실제로 접속할 때마다 다른 이미지를 보여주는 샘플 URL입니다.
            callerImage: "https://picsum.photos/200"
        )
    }
    
    /// 또 다른 샘플이 필요한 경우 추가할 수 있습니다.
    static var sample2: IncomingCallPayload {
        return IncomingCallPayload(
            type: "INCOMING_CALL",
            callId: 54321,
            agoraChannel: "another_channel_sample",
            agoraToken: "008fFgBk8HgJoO8F6bA8c8d...<아고라 토큰은 매우 길기 때문에 임의의 값으로 대체>...BgBBBBBBhGBs/gIA",
            callerId: 1122,
            callerName: "이영희",
            // 정사각형의 다른 샘플 이미지 URL입니다.
            callerImage: "https://source.unsplash.com/random/200x200?person"
        )
    }
}


// 최상위 응답을 감싸는 구조체
public struct AcceptCallResponse: Codable {
    public let status: Int
    public let data: CallData?
    public let errorMessage: String?
}

// "data" 객체에 해당하는 구조체
public struct CallData: Codable {
    public let accepted: Bool
    public let token: String
    public let channelName: String
    public let callerId: Int
    public let receiverId: Int
    public let callStatus: String
    public let duration: Int
    public let callerProfile: CallUserProfile
    public let receiverProfile: CallUserProfile
}

// callerProfile과 receiverProfile에 공통으로 사용되는 유저 프로필 구조체
public struct CallUserProfile: Codable {
    public let id: Int
    public let nickname: String
    public let age: Int
    public let interests: [String]
    
    // ✅ KEY POINT: null 값이 올 수 있는 필드들을 옵셔널(?)로 선언
    public let location: String?
    public let profileImageUrl: String?
}
