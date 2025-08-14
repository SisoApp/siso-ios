//
//  ProfilePAge.swift
//  profile
//
//  Created by 멘태 on 8/13/25.
//

public enum ProfilePage: String, Identifiable, Hashable {
    case basic, interest, image, introduce
    
    public var id: String { self.rawValue }
}
