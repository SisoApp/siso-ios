//
//  CallActions.swift
//  call
//
//  Created by jdios on 8/19/25.
//

import Foundation
import model

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

public enum CallState: Equatable {
    // Equatable을 채택하여 상태 변경을 더 쉽게 감지할 수 있습니다.
    
    /// 통화 관련 활동이 없는 유휴 상태
    case idle
    
    /// A에게서 전화가 오고 있는 수신 상태 (B의 입장)
    case receiving(info: FCMDTO)
    
    /// B에게 전화를 걸고 있는 발신 상태 (A의 입장)
    case connecting(info: FCMDTO)
    
    /// 통화가 연결되어 진행 중인 상태
    case inCall(info: FCMDTO)
    
    // Equatable 구현
    public static func == (lhs: CallState, rhs: CallState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.receiving(let lhsInfo), .receiving(let rhsInfo)):
            return lhsInfo.id == rhsInfo.id
        case (.connecting(let lhsInfo), .connecting(let rhsInfo)):
            return lhsInfo.id == rhsInfo.id
        case (.inCall(let lhsInfo), .inCall(let rhsInfo)):
            return lhsInfo.id == rhsInfo.id
        default:
            return false
        }
    }
}
