//
//  AuthEnum.swift
//  auth
//
//  Created by 멘태 on 8/13/25.
//

public enum AuthPage: String, Identifiable, Hashable {
    case login, agree1, agree2
    
    public var id: String { self.rawValue }
}

public enum AuthSheet: String, Identifiable, Hashable {
    case auth

    public var id: String { self.rawValue }
}
