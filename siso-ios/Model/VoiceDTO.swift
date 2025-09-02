//
//  VoiceDTO.swift
//  model
//
//  Created by 멘태 on 9/2/25.
//

import Foundation

public struct VoiceDTO: Codable, Sendable {
    let id: Int
    let userId: Int
    let url: String
    let duration: String
    let updatedAt: String
}
