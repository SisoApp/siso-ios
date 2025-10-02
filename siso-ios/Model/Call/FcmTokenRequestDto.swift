// FcmTokenRequestDto.swift

import Foundation

/// FCM 토큰 등록 요청 시 Body에 담길 DTO
public struct FcmTokenRequestDto: Encodable {
    public let userId: Int
    public let token: String
    
    public init(userId: Int, token: String) {
        self.userId = userId
        self.token = token
    }
}
