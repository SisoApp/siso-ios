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
