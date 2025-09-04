//
//  ImageDTO.swift
//  model
//
//  Created by 멘태 on 9/2/25.
//

import Foundation

public struct ImageDTO: Codable, Sendable {
    public let id: Int
    public let userId: Int
    //public let path: String
    public let serverImageName: String
    public let originalName: String
    public let presignedUrl: String
}
