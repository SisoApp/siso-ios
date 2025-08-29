//
//  CallPage.swift
//  call
//
//  Created by jdios on 8/20/25.
//

import Foundation
import model
public enum CallPage: Identifiable, Hashable, Equatable {
    case manner(opponentProfile: UserProfileServer)
//    case connecting(opponentProfile: UserProfileServer)
//    case calling(viewModel: CallViewModel) // ViewModel은 Hashable/Equatable을 준수해야 합니다.
//    case incomingCall(callInfo: IncomingCallInfo)
    case activeCall
    case reportFeedbackPopup
    
    public var id: String {
        switch self {
        case .manner: return "manner"
        case .activeCall: return "activeCall"
//        case .connecting: return "connecting"
//        case .calling: return "calling"
//        case .incomingCall: return "incomingCall"
        case .reportFeedbackPopup: return "reportFeedbackPopup"
        }
    }
    public func hash(into hasher: inout Hasher) {
          hasher.combine(self.id) // 각 케이스의 기본 해시값은 id로 통일
          switch self {
          // 연관값이 있는 경우, 연관값의 고유 ID도 함께 해싱합니다.
//          case .connecting(let opponentProfile):
//              hasher.combine(opponentProfile.id)
//          case .calling(let viewModel):
//              hasher.combine(viewModel.id) // ViewModel이 Identifiable 하다고 가정
//          case .incomingCall(let callInfo):
//              hasher.combine(callInfo.id)
          default:
              break // 연관값 없는 케이스는 id 해싱만으로 충분
          }
      }
    public static func == (lhs: CallPage, rhs: CallPage) -> Bool {
           switch (lhs, rhs) {
           case (.manner, .manner),
                (.reportFeedbackPopup, .reportFeedbackPopup):
               return true
//           case (.connecting(let lhsProfile), .connecting(let rhsProfile)):
//               return lhsProfile.id == rhsProfile.id
//           case (.calling(let lhsVM), .calling(let rhsVM)):
//               return lhsVM === rhsVM // 클래스는 참조(===)로 비교
//           case (.incomingCall(let lhsInfo), .incomingCall(let rhsInfo)):
//               return lhsInfo.id == rhsInfo.id
           default:
               return false
           }
       }
}

// CallSheet도 동일하게 수정합니다.
public enum CallSheet: Identifiable, Hashable {
    case report(opponentProfile: UserProfileServer)
    
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
