//
//  AuthEnum.swift
//  auth
//
//  Created by 멘태 on 8/13/25.
//

public enum AuthPage: String, Identifiable, Hashable {
    case login, accept, welcome
    
    public var id: String { self.rawValue }
}

public enum AuthSheet: Identifiable, Hashable {
    case consent(title: String ,content: String)
    
    public var id: String {
        switch self {
        case .consent(let title ,let content):
            return content
        }
    }
    
    public static func == (lhs: AuthSheet, rhs: AuthSheet) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
