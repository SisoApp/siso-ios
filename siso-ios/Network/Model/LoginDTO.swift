//
//  LoginDTO.swift
//  siso-ios
//
//  Created by 김용해 on 8/21/25.
//

import SwiftUI

// MARK: - 소셜 로그인: KAKAO | APPLE
public enum SocialLoginType: String, Codable, Sendable {
    case kakao = "KAKAO"
    case apple = "APPLE"
}

// MARK: TOKEN RESPONSE
public struct Token: Codable, Sendable {
    let refreshToken: String
    let registrationStatus: String
}

// MARK: User Model Object
public struct User: Sendable, Codable {
    let userId: Int
    let socialLogin: SocialLoginType
    let email: String
    let phoneNumber: String
    let isDeleted: Bool
    let isBlock: Bool
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case socialLogin = "provider"
        case email
        case phoneNumber
        case isDeleted = "deleted"
        case isBlock = "block"
    }
}

// TODO: AUTO LOGIN RESPONSE OBJECT
public struct AutoLoginResponse: Sendable ,Codable {
    let accessToken: String
    let user: User
    let token: Token
}


// TODO: 실제 뷰모델에서 사용 될 로그인 응답 객체
public struct RefreshResult {
    public let user: User
    public let registrationStatus: String
    
    public init(user: User, registrationStatus: String) {
        self.user = user
        self.registrationStatus = registrationStatus
    }
}
