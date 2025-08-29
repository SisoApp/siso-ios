//
//  UserDTO.swift
//  network
//
//  Created by jdios on 8/29/25.
//

import Foundation


/// 서버로부터 사용자 정보를 응답받을 때 사용하는 데이터 모델
public struct UserResponseDto: Decodable {
    public let id: Int64 // Long은 Int64로 매핑
    public let provider: Provider
    public let email: String
    public let phoneNumber: String
    public let isDeleted: Bool
    public let isBlock: Bool
    
    
}
