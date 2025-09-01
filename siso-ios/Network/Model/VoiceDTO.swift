//
//  VoiceDTO.swift
//  profile
//
//  Created by 멘태 on 8/31/25.
//

import Foundation

public struct VoiceResponseDTO: Codable, Sendable {
    let id: Int
    let userId: Int
    let url: String
    let duration: Int
    let fileSize: Int
}
