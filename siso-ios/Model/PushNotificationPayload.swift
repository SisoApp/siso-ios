// In 'model' module

import Foundation

/// 푸시 알림을 통해 수신되는 통화 요청 데이터 모델입니다.
/// 발신자 정보와 Agora 접속 정보를 포함합니다.
public struct IncomingCallPayload: Decodable, Equatable, Encodable {
    public init(type: String, callId: Int, agoraChannel: String, agoraToken: String, callerId: Int, callerName: String, callerImage: String) {
        self.type = type
        self.callId = callId
        self.agoraChannel = agoraChannel
        self.agoraToken = agoraToken
        self.callerId = callerId
        self.callerName = callerName
        self.callerImage = callerImage
    }
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
        
        // 1. String 타입은 그대로 디코딩합니다.
        self.type = try container.decode(String.self, forKey: .type)
        self.agoraChannel = try container.decode(String.self, forKey: .agoraChannel)
        self.agoraToken = try container.decode(String.self, forKey: .agoraToken)
        self.callerName = try container.decode(String.self, forKey: .callerName)
        self.callerImage = try container.decode(String.self, forKey: .callerImage)
        
        // 2. Int 타입으로 기대하는 필드들을 위한 커스텀 로직
        // 먼저 String으로 디코딩을 시도합니다.
        let callIdString = try container.decode(String.self, forKey: .callId)
        let callerIdString = try container.decode(String.self, forKey: .callerId)
        
        // String을 Int로 변환합니다. 변환에 실패하면 에러를 던집니다.
        guard let callIdInt = Int(callIdString) else {
            throw DecodingError.dataCorruptedError(forKey: .callId, in: container, debugDescription: "callId를 Int로 변환할 수 없습니다: \(callIdString)")
        }
        self.callId = callIdInt
        
        guard let callerIdInt = Int(callerIdString) else {
            throw DecodingError.dataCorruptedError(forKey: .callerId, in: container, debugDescription: "callerId를 Int로 변환할 수 없습니다: \(callerIdString)")
        }
        self.callerId = callerIdInt
    }
    
}
