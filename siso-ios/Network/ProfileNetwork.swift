//
//  ProfileNetwork.swift
//  network
//
//  Created by 멘태 on 8/27/25.
//

import UIKit
import Alamofire

public final actor ProfileNetworkManager: Sendable {
    public static let shared: ProfileNetworkManager = .init()
    private let baseUrl: String?
    
    public init() {
        self.baseUrl = Bundle.main.infoDictionary?["SERVER_URL"] as? String
    }
    
    public func registerProfile(_ parameters: [String: Any]) async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/profiles"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let refreshToken = KeyChainManager.shared.get(for: "refreshToken") else {
            throw AFError.invalidURL(url: "refreshToken -> nil")
        }
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw AFError.invalidURL(url: "accessToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        print("----------------Register Profile------------------")
        print("url: \(url)")
        print("accessToken: \(accessToken)")
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    break
                case .failure(let error):
                    print("프로필 등록 실패: ", error.localizedDescription)
                    
                    if let data  = response.data, let body = String(data: data, encoding: .utf8) {
                        print("body: \(body)")
                    }
                }
            }
    }
    
    public func updateProfile(_ parameters: [String: Any]) async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/profiles"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let refreshToken = KeyChainManager.shared.get(for: "refreshToken") else {
            throw AFError.invalidURL(url: "refreshToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(refreshToken)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url,
                   method: .patch,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    print("프로필 업로드 성공!")
                case .failure(let error):
                    print("프로필 등록 실패: ", error.localizedDescription)
                    
                    if let data  = response.data, let body = String(data: data, encoding: .utf8) {
                        print("body: \(body)")
                    }
                }
            }
    }
}
