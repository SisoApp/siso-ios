//
//  CallActions.swift
//  call
//
//  Created by jdios on 8/19/25.
//

import Foundation

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

public enum CallViewActions {
    // MARK: - Call State Changes
    case muteModeOn
    
    case muteModeOff
    
    case speakerModeOn
    
    case speakerModeOff
    
}

public enum CallCoordinatorActions {
    
}

public enum CallState {
    // 아고라 서버에 들어가 대기하고 있는 상태
    case connecting
    // 연결 완료된 상태 - 아고라 서버에 두 사람이 들어와 있는 상태
    case connected
    // 전화중인 상태
    case calling
    // 전화가 끝나고 팝업이 뜨는 시점
    case callEnded
    // 전화 하고 있지 않으며 전화 받을 수 있는 상태
    case waiting
}
