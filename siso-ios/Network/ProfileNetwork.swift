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
    
    public func getProfiles() async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/profiles"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw AFError.invalidURL(url: "accessToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url,
                   method: .get,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                if let data  = response.data, let body = String(data: data, encoding: .utf8) {
                    print("body: \(body)")
                }
                
                switch response.result {
                case .success:
                    print("전체 프로필 조회 성공!")
                    break
                case .failure(let error):
                    print("전체 프로필 조회 실패!")
                    print(error)
                    break
                }
            }
    }
    
    public func getMyProfile() async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/profiles/me"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw AFError.invalidURL(url: "accessToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        print("----------------get My Profile------------------")
        print("url: \(url)")
        print("accessToken: \(accessToken)")
        
        AF.request(url,
                   method: .get,
                   headers: headers)
        .validate(statusCode: 200..<300)
            .response { response in
                if let data  = response.data, let body = String(data: data, encoding: .utf8) {
                    print("body: \(body)")
                }
                
                switch response.result {
                case .success:
                    print("프로필 조회 성공!")
                case .failure(let error):
                    print("프로필 조회 실패!")
                }
            }
    }
    
    public func registerProfile(_ parameters: [String: Any]) async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/profiles"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw AFError.invalidURL(url: "accessToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                if let data  = response.data, let body = String(data: data, encoding: .utf8) {
                    print("body: \(body)")
                }
                
                switch response.result {
                case .success:
                    print("프로필 등록 성공!")
                case .failure(let error):
                    print("프로필 등록 실패: ", error.localizedDescription)
                }
            }
    }
    
    public func updateProfile(_ parameters: [String: Any]) async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/profiles"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw AFError.invalidURL(url: "accessToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url,
                   method: .patch,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                if let data  = response.data, let body = String(data: data, encoding: .utf8) {
                    print("body: \(body)")
                }
                
                switch response.result {
                case .success:
                    print("프로필 업로드 성공!")
                case .failure(let error):
                    print("프로필 등록 실패: ", error.localizedDescription)
                }
            }
    }
}
