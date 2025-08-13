//
//  User.swift
//  siso-ios
//
//  Created by jdios on 8/12/25.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    var id: String {
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
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.phoneNumber == rhs.phoneNumber
    }
}
