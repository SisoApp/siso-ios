//
//  CallActions.swift
//  call
//
//  Created by jdios on 8/19/25.
//

import Foundation
import model
import network

public enum CallAgoraActions {
    // MARK: - Core Calling Actions
    // Create Agora Channel and Join that Room
    case startCall
    // Destroy Agora Channel and exit and kick other User
    case endCall
    // while do non-call actions, inturupt the flow and receive channel invite
    case receiveCall
    // accept invite and join that channel
    case joinCall
}

// MARK: - Call State Changes
public enum CallViewActions {
    
    case muteModeOn
    
    case muteModeOff
    
    case speakerModeOn
    
    case speakerModeOff
    
}

// 1. 중첩된 enum을 제거하고, Equatable 프로토콜 채택
public enum CallState: Equatable {
    
    case idle // 통화 없음
    
    // ✅ 발신 중: 상대방 프로필(profile)과 통신 정보(info)를 모두 가짐
    case connecting(profile: MatchingProfile, info: CallInfoDto)
    
    // ✅ 수신 중: 처음엔 통신 정보(info)만 가짐
    case receiving(payload: IncomingCallPayload)
    
    // ✅ 통화 중: 상대방 프로필(profile)과 통신 정보(info)를 모두 가짐
    case inCall(profile: MatchingProfile, info: CallInfoDto)
    
    
    // ✅ 평가 대기: 통화가 끝난 후 평가를 위해 프로필과 통신 정보를 가짐
    case assessment(profile: MatchingProfile, info: CallInfoDto)
    
    // 3. Equatable 구현부를 새로운 구조에 맞게 수정
    public static func == (lhs: CallState, rhs: CallState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
            
            // 'connecting' 상태 비교: 프로필 ID와 통화 ID가 모두 같아야 함
        case (.connecting(let lhsProfile, let lhsInfo), .connecting(let rhsProfile, let rhsInfo)):
            return lhsProfile.id == rhsProfile.id && lhsInfo.id == rhsInfo.id
            
            // 'receiving' 상태 비교: 통화 ID가 같아야 함
        case (.receiving(let lhsInfo), .receiving(let rhsInfo)):
            return lhsInfo.callId == rhsInfo.callId
            
            // 'inCall' 상태 비교: 프로필 ID와 통화 ID가 모두 같아야 함
        case (.inCall(let lhsProfile, let lhsInfo), .inCall(let rhsProfile, let rhsInfo)):
            return lhsProfile.id == rhsProfile.id && lhsInfo.id == rhsInfo.id
            
            // 위에 해당하지 않는 모든 다른 조합은 '다름'으로 간주
        default:
            return false
        }
    }
}
