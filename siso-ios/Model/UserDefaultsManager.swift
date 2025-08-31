//
//  UserDefaultsManager.swift
//  model
//
//  Created by 멘태 on 8/31/25.
//

import Foundation

public final class UserDefaultsManager {
    public static let shared: UserDefaultsManager = .init()
    
    private let userIdKey: String = "currentUserId"
    
    public init() {}
    
    public func saveCurrent(userId: Int) {
        print("save user id: \(userId)")
        UserDefaults.standard.set(userId, forKey: userIdKey)
    }
    
    public func getCurrentUserId() -> Int? {
        return UserDefaults.standard.object(forKey: userIdKey) as? Int
    }
    
    public func removeCurrentUserId() {
        UserDefaults.standard.removeObject(forKey: userIdKey)
    }
}
