//
//  LoginNetwork.swift
//  siso-ios
//
//  Created by 김용해 on 8/14/25.
//

import Foundation
import Alamofire
import CryptoKit
import model

// MARK: - Network Manager

public final actor LoginNetworkManager: Sendable {
    
    private let keychain = KeyChainManager.shared
    private let baseURL: String?
    
    public init() {
        baseURL = Bundle.main.infoDictionary?["SERVER_URL"] as? String
    }
    
    // MARK: - Authentication
    /// ** MARK: 소셜 로그인을 통해 서버에 로그인하고 토큰을 발급받습니다. Login
    public func login(at accessToken: String, completionHandler: @escaping(String, AFError?) -> Void) async throws {
        guard let baseURL = baseURL else { throw AFError.invalidURL(url: "base URL is Not Found") }
        let urlString = "\(baseURL)/api/auth/kakao"
        
        guard let url = URL(string: urlString) else {
            throw AFError.invalidURL(url: urlString)
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: String] = [
            "accessToken": accessToken,
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: Token.self) { [weak self] response in
            switch response.result {
            case .success(var token):
                // 2. KeyChainManager를 사용해 RefreshToken 토큰 저장
                self?.keychain.save(token: token.accessToken, for: "accessToken")
                self?.keychain.save(token: token.refreshToken, for: "refreshToken")
                if !token.hasProfile  {
                    token.registrationStatus = "REGISTER" // 동의 항목 이동
                }
                completionHandler(token.registrationStatus, nil)
            case .failure(let error):
                completionHandler("", error)
                return
            }
        }
    }
    
    /// ** MARK: 저장된 리프레시 토큰을 사용하여 자동으로 로그인합니다.
    public func autoLogin() async throws -> Result<RefreshResult, AFError> {
        guard let refreshToken = keychain.get(for: "refreshToken") else {
            return .failure(.invalidURL(url: "refreshToken -> nil"))
        }
        
        do {
            /// refreshToken을 가지고 서버에 보내서 비교
            /// 만료되었다면 다시 로그인 시키고 아직 만료까지 남아있다면 토근 재발급 해서 갱신하기
            let res = try await getRefreshToken(refreshToken: refreshToken)
            print("res : \(res)")
            return .success(res)
        } catch {
            return .failure(.sessionInvalidated(error: error))
        }
    }
    
    /// ** MARK: 리프레시 토큰으로 새로운 액세스 토큰을 발급받습니다. -> 재발급
    public func getRefreshToken(refreshToken: String) async throws -> RefreshResult {
        guard let baseURL = baseURL else { throw AFError.invalidURL(url: "base URL is Not Found") }
        let urlString = "\(baseURL)/api/auth/refresh"
        
        guard let url = URL(string: urlString) else {
            throw AFError.invalidURL(url: urlString)
        }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(refreshToken)"]
        
        var response = try await AF.request(url, method: .post, headers: headers)
            .validate(statusCode: 200..<300)
            .serializingDecodable(AutoLoginResponse.self)
            .value
        
        // 새로 받은 토큰을 다시 저장
        keychain.save(token: response.token.accessToken, for: "accessToken")
        keychain.save(token: response.token.refreshToken, for: "refreshToken")
        print("refreshToken : \(response.token.refreshToken)")
        if !response.token.hasProfile {
            response.token.registrationStatus = "REGISTER"
        }
        
        return RefreshResult(user: response.user, registrationStatus: response.token.registrationStatus)
    }
    
    /// 로그아웃하고 모든 토큰을 삭제합니다.
    public func logout() {
        // 5. KeyChainManager를 호출하여 모든 토큰 삭제
        keychain.clearAllTokens()
    }
}
