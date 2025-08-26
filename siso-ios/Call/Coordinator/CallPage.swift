//
//  CallPage.swift
//  call
//
//  Created by jdios on 8/20/25.
//

import Foundation
import model
public enum CallPage: String, Identifiable, Hashable {
    case connecting, calling, called
    
    public var id: String {self.rawValue}
}

public enum CallSheet: Identifiable, Equatable {
    
    case afterCallPopup(opponent: UserProfileServer)
    
    // Identifiable 프로토콜을 준수하기 위한 id 프로퍼티
    public var id: String {
        switch self {
        case .afterCallPopup(let opponent):
            // Equatable을 위해 opponent의 고유한 값(예: nickname 또는 id)을 사용
            return "afterCallPopup_\(opponent.nickname)"
        }
    }
    public static func == (lhs: CallSheet, rhs: CallSheet) -> Bool {
        switch (lhs, rhs) {
        case (.afterCallPopup(let lhsOpponent), .afterCallPopup(let rhsOpponent)):
            return lhsOpponent.nickname == rhsOpponent.nickname
        }
    }
}
