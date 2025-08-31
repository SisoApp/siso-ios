//
//  ProfileDTO\.swift
//  network
//
//  Created by 멘태 on 8/27/25.
//
import Foundation

public struct Profile: Codable, Sendable {
    let id: Int
    let userId: Int
    let drinkingCapacity: String
    let religion: String
    let isSmoke: Bool
    let age: Int
    let nickname: String
    let introduce: String
    let profileImage: URL
    let location: String
    let sex: String
    let mbti: String
    let preferenceSex: String
    let bond: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case drinkingCapacity = "drinking_capacity"
        case isSmoke = "is_smoke"
        case profileImage = "profile_image"
        case preferenceSex = "preference_sex"
        case id, religion, age, nickname, introduce, location, sex, mbti, bond
    }
}

public struct Voice: Codable, Sendable {
    let id: Int
    let userId: Int
    let url: String
    let duration: Int
    let fileSize: Int
}

public struct Image: Codable, Sendable {
    let id: Int
    let userId: Int
    let path: String
    let serverImageName: String
    let originalName: String
}
