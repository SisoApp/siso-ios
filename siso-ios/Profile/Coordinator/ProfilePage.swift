//
//  ProfilePAge.swift
//  profile
//
//  Created by 멘태 on 8/13/25.
//
import SwiftUI

public enum ProfilePage: String, Identifiable, Hashable {
    case basic, interest, image, introduce
    
    public var id: String { self.rawValue }
}

public enum ProfileSheet: Identifiable, Hashable {
    case imageHelper(([UIImage]) -> Void)
    case cameraSheet
    
    public var id: String {
        switch self {
        case .imageHelper:
            return "imageHelper"
        case .cameraSheet:
            return "cameraSheet"
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id) // 클로저는 해싱 불가, id로 대체
    }
    
    public static func ==(lhs: ProfileSheet, rhs: ProfileSheet) -> Bool {
        lhs.id == rhs.id
    }
}
