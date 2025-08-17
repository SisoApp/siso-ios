//
//  LoginNetwork.swift
//  siso-ios
//
//  Created by 김용해 on 8/14/25.
//

import Foundation
import Alamofire

// MARK: - Models
public enum SocialLoginType: String, Codable, Sendable {
    case kakao
    case apple
}

// MARK: token의 종류
public struct Token: Codable {
    let acessToken: String
    let refreshToken: String
}

// MARK: User Model
public struct User: Sendable, Codable {
    let socialLogin: SocialLoginType
    let phoneNumber: String
    let isOnline: Bool
    let isNotificationSubscribed: Bool
    let refreshToken: String
    let isBlock: Bool
    let isDeleted: Bool
    let createdAt: String
    let updatedAt: String
}

// MARK: - Network Error

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
    case unauthorized
    case unknown(Error)
}

// MARK: - Network Manager

public final class NetworkManager {
    
    public static let shared = NetworkManager()
    private let baseURL = "https://your-server.com/api"
    private let keychain = KeyChainManager.shared
    
    private init() {}
    
    // MARK: - Authentication
    
    /// 소셜 로그인을 통해 서버에 로그인하고 토큰을 발급받습니다.
    public func login(with socialLoginType: SocialLoginType, accessToken: String, completion: @escaping (Result<User, NetworkError>) -> Void) {
        let urlString = "\(baseURL)/auth/login/\(socialLoginType.rawValue)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let parameters: [String : Any] = [
            "provider": socialLoginType.rawValue,
            "accessToken": accessToken,
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Token.self) { response in
                switch response.result {
                case .success(let token):
                    // 2. KeyChainManager를 사용해 RefreshToken 토큰 저장
                    self.keychain.save(token: token.refreshToken, for: "refreshToken")
                    // 3. 새로 받은 accessToken으로 사용자 프로필 정보를 가져옴
                    self.fetchUserProfile(completion: completion)
                    
                case .failure(let error):
                    // 401 에러(Unauthorized)를 별도로 처리하면 더 좋습니다.
                    if response.response?.statusCode == 401 {
                        completion(.failure(.unauthorized))
                    } else {
                        completion(.failure(.serverError(error.localizedDescription)))
                    }
                }
            }
    }
    
    /// 저장된 리프레시 토큰을 사용하여 자동으로 로그인합니다.
    /// 중간에 서버통신 코드 있어야 할 듯
    public func autoLogin(completion: @escaping (Result<User, NetworkError>) -> Void) {
        guard let refreshToken = keychain.get(for: "refreshToken") else {
            completion(.failure(.unauthorized))
            return
        }
        
        // 4. 새로 구현된 refreshToken 함수를 호출
        self.refreshToken { result in
            switch result {
            case .success:
                // 토큰 갱신 성공 시, 사용자 프로필 정보를 가져옴
                self.fetchUserProfile(completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 리프레시 토큰으로 새로운 액세스 토큰을 발급받습니다.
    public func refreshToken(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let urlString = "\(baseURL)/auth/refresh"
        
        guard let url = URL(string: urlString), let refreshToken = keychain.get(for: "refreshToken") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(refreshToken)"]
        
        AF.request(url, method: .post, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Token.self) { response in
                switch response.result {
                case .success(let token):
                    // 새로 받은 토큰들을 다시 저장
                    self.keychain.save(token: token.refreshToken, for: "refreshToken")
                    completion(.success(()))
                case .failure:
                    // 리프레시 실패는 보통 리프레시 토큰 만료를 의미하므로 unauthorized 처리
                    completion(.failure(.unauthorized))
                }
            }
    }
    
    /// 로그아웃하고 모든 토큰을 삭제합니다.
    public func logout() {
        // 5. KeyChainManager를 호출하여 모든 토큰 삭제
        keychain.clearAllTokens()
    }
    
    // MARK: - User Profile
    
    /// 사용자 프로필 정보를 가져옵니다.
    public func fetchUserProfile(completion: @escaping (Result<User, NetworkError>) -> Void) {
        let urlString = "\(baseURL)/users/me"
        
        guard let url = URL(string: urlString), let accessToken = keychain.get(for: "accessToken") else {
            completion(.failure(.unauthorized)) // accessToken이 없으면 unauthorized
            return
        }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let user):
                    completion(.success(user))
                case .failure:
                    if response.response?.statusCode == 401 {
                        completion(.failure(.unauthorized))
                    } else {
                        completion(.failure(.decodingError))
                    }
                }
            }
    }
}
