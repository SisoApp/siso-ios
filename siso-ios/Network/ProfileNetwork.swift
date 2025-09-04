//
//  ProfileNetwork.swift
//  network
//
//  Created by 멘태 on 8/27/25.
//

import UIKit
import Alamofire
import model

public struct UserProfileRequest: Codable {
    let drinkingCapacity: String
    
}

public final actor ProfileNetworkManager: Sendable {
    public static let shared: ProfileNetworkManager = .init()
    private let baseUrl: String?
    
    public init() {
        self.baseUrl = Bundle.main.infoDictionary?["SERVER_URL"] as? String
    }
    
    public func getProfiles(completion: @escaping ([UserProfileDTO]) -> Void) async throws {
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
            .responseDecodable(of: [UserProfileDTO].self) { response in
                switch response.result {
                case .success(let profiles):
                   
                    completion(profiles)
                case .failure(let error):
                   
                    print(error.localizedDescription)
                
                }
            }
    }
    
    public func getUserProfile(for id: Int) async throws -> UserProfileDTO {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/profiles/\(id)"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw AFError.invalidURL(url: "accessToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        return await withCheckedContinuation { continuation in
            AF.request(url,
                       method: .get,
                       headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: UserProfileDTO.self) { response in
                switch response.result {
                case .success(let profile):
                    continuation.resume(returning: profile)
                case .failure(let error):
                    debugPrint("프로필 조회 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    public func getCurrentUserProfile() async throws -> UserProfileDTO {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/profiles/me"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw AFError.invalidURL(url: "accessToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]

        return await withCheckedContinuation { continuation in
            AF.request(url,
                       method: .get,
                       headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: UserProfileDTO.self) { response in
                switch response.result {
                case .success(let profile):
                    continuation.resume(returning: profile)
                case .failure(let error):
                    debugPrint("프로필 조회 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func fetchProfile(url: URL,_ completion: @escaping (UserProfileDTO) -> Void) async throws {
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw AFError.invalidURL(url: "accessToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        

        AF.request(url,
                   method: .get,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: UserProfileDTO.self) { response in
                switch response.result {
                case .success(let profile):

                    completion(profile)
                case .failure(let error):
                    debugPrint("프로필 조회 실패: \(error.localizedDescription)")
                }
            }
    }
    
    public func registerProfile(_ parameters: UserProfileDTO) async throws {
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
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url,
                       method: .post,
                       parameters: parameters,
                       encoder: JSONParameterEncoder.default,
                       headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    debugPrint("프로필 등록 성공!")
                    continuation.resume()
                case .failure(let error):
                    debugPrint("프로필 등록 실패: ", error.localizedDescription)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func updateProfile(_ parameters: UserProfileDTO, completion: @escaping (UserProfileDTO) -> Void) async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/profiles"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw AFError.invalidURL(url: "accessToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url,
                   method: .patch,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: UserProfileDTO.self) { response in
                switch response.result {
                case .success(let profile):
                    debugPrint("프로필 등록 성공!")
                    completion(profile)
                case .failure(let error):
                    debugPrint("프로필 수정 실패: \(error.localizedDescription)")
                }
            }
    }
    
    public func getInterests(completion: @escaping ([Interest]) -> Void) async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/interests/list"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw AFError.invalidURL(url: "accessToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url,
                   method: .get,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: InterestResponseDTO.self) { response in
                switch response.result {
                case .success(let interestDTO):
                    debugPrint("관심사 조회 성공!: \(interestDTO.data)")
                    completion(interestDTO.data.map { $0.interest })
                case .failure(let error):
                    debugPrint("관심사 조회 실패: \(error.localizedDescription)")
                }
            }
    }
    
    public func registerInterests(_ parameters: [InterestRequestDTO]) async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/interests/select"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw AFError.invalidURL(url: "accessToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    debugPrint("관심사 등록 성공!")
                case .failure(let error):
                    debugPrint("관심사 등록 실패: \(error.localizedDescription)")
                }
            }
    }
    
    public func updateInterests(_ parameters: [InterestRequestDTO]) async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/interests/update"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw AFError.invalidURL(url: "accessToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url,
                   method: .patch,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    debugPrint("관심사 수정 성공!")
                case .failure(let error):
                    debugPrint("관심사 수정 실패: \(error.localizedDescription)")
                }
            }
    }
}
