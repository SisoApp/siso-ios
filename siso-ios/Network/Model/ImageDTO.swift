//
//  ImageDTO.swift
//  profile
//
//  Created by 멘태 on 8/31/25.
//

import Foundation

public struct ImageDTO: Codable, Sendable {
    let id: Int
    let userId: Int
    let path: String
    let serverImageName: String
    let originalName: String
}
