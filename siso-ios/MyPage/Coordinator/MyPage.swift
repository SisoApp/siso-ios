//
//  MyPage.swift
//  auth
//
//  Created by 멘태 on 8/19/25.
//

public enum MyPage: String, Identifiable, Hashable {
    case main, setting, notification
    
    public var id: String { return self.rawValue }
}
