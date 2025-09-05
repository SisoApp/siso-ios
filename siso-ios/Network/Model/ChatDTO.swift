//
//  ChatDTO.swift
//  network
//
//  Created by 김용해 on 9/3/25.
//

import Foundation
import model

public struct ChatDTO: Codable {
    let status: Int
    let data: [ChatRoomResponseDTO]?
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case errorMessage = "errorMessage"
    }
}
