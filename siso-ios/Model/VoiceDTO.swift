//
//  VoiceDTO.swift
//  model
//
//  Created by 멘태 on 9/2/25.
//

import Foundation

public struct VoiceDTO: Codable, Sendable {
    public let id: Int
    public let userId: Int
    public let url: String
    public let duration: String
}
