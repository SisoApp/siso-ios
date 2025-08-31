//
//  CallPage.swift
//  call
//
//  Created by jdios on 8/20/25.
//

import Foundation
import model
public enum CallPage: Identifiable, Hashable, Equatable {
    case manner(opponentProfile: MatchingProfile)
//    case connecting(opponentProfile: UserProfileServer)
//    case calling(viewModel: CallViewModel) // ViewModel은 Hashable/Equatable을 준수해야 합니다.
//    case incomingCall(callInfo: IncomingCallInfo)
    case activeCall
    case reportFeedbackPopup
    
    public var id: String {
        switch self {
        case .manner: return "manner"
        case .activeCall: return "activeCall"

        case .reportFeedbackPopup: return "reportFeedbackPopup"
        }
    }
    public func hash(into hasher: inout Hasher) {
          hasher.combine(self.id) // 각 케이스의 기본 해시값은 id로 통일
      }
    public static func == (lhs: CallPage, rhs: CallPage) -> Bool {
           switch (lhs, rhs) {
           case (.manner, .manner),
                (.reportFeedbackPopup, .reportFeedbackPopup):
               return true

           default:
               return false
           }
       }
}

// CallSheet도 동일하게 수정합니다.
public enum CallSheet: Identifiable, Hashable {
    case report(opponent: CallInfoDto)
    
    public var id: String {
        switch self {
        case .report:
            return "report"
        }
    }
    
    // Hashable & Equatable 구현
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        switch self {
        case .report(let opponentProfile):
            hasher.combine(opponentProfile.id)
        }
    }
    
    public static func == (lhs: CallSheet, rhs: CallSheet) -> Bool {
        switch (lhs, rhs) {
        case (.report(let lhsProfile), .report(let rhsProfile)):
            return lhsProfile.id == rhsProfile.id
        }
    }
}
