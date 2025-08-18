//
//  User.swift
//  siso-ios
//
//  Created by jdios on 8/12/25.
//

import Foundation

public struct User: Codable, Identifiable, Equatable {
    public var id: String {
            return phoneNumber
        }
    
    var socailLogin: String
    var phoneNumber: String
    var isOnline: Bool
    let isNotificationSubscribed: Bool
    var refreshtoken: String
    var isBlock: Bool
    var isDeleted: Bool
    let createdAt: String
    var updatedAt: String
    
    public init(socailLogin: String, phoneNumber: String, isOnline: Bool, isNotificationSubscribed: Bool, refreshtoken: String, isBlock: Bool, isDeleted: Bool, createdAt: String, updatedAt: String) {
        self.socailLogin = socailLogin
        self.phoneNumber = phoneNumber
        self.isOnline = isOnline
        self.isNotificationSubscribed = isNotificationSubscribed
        self.refreshtoken = refreshtoken
        self.isBlock = isBlock
        self.isDeleted = isDeleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.phoneNumber == rhs.phoneNumber
    }
}
