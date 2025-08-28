//
//  ProfileNetwork.swift
//  network
//
//  Created by 멘태 on 8/27/25.
//

import UIKit
import Alamofire

public final actor ProfileNetworkManager: Sendable {
    public static let shard: ProfileNetworkManager = .init()
    private let baseUrl: String?
    
    public init() {
        self.baseUrl = Bundle.main.infoDictionary?["SERVER_URL"] as? String
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
        
        print(accessToken)
        print(parameters)
        
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
                    break
                case .failure(let error):
                    print("프로필 등록 실패: ", error.localizedDescription)
                    
                    if let data  = response.data, let body = String(data: data, encoding: .utf8) {
                        print("body: \(body)")
                    }
                }
            }
    }
    
    public func uploadVoice() async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/voice-samples/upload"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let refreshToken = KeyChainManager.shared.get(for: "refreshToken") else {
            throw AFError.invalidURL(url: "refreshToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(refreshToken)"
        ]
        
        print(refreshToken)
        
        AF.upload(
            multipartFormData: { multipartFormData in
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let fileURL = paths[0].appendingPathComponent("voice.m4a")
                
                multipartFormData.append(fileURL,
                                         withName: "file",
                                         fileName: fileURL.lastPathComponent,
                                         mimeType: "audio/m4a")
            },
            to: url,
            method: .post,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success:
                print("녹음파일 업로드 성공!")
            case .failure(let error):
                print("녹음파일 업로드 실패: ", error.localizedDescription)
                
                if let data  = response.data, let body = String(data: data, encoding: .utf8) {
                    print("body: \(body)")
                }
            }
        }
    }
    
    public func uploadImages(_ images: [UIImage]) async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/images/upload"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let refreshToken = KeyChainManager.shared.get(for: "refreshToken") else {
            throw AFError.invalidURL(url: "refreshToken -> nil")
        }
        
        print(refreshToken)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(refreshToken)"
        ]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (index, image) in images.enumerated() {
                    if let imageData = image.jpegData(compressionQuality: 1.0) {
                        multipartFormData.append(
                            imageData,
                            withName: "file",
                            fileName: "image\(index).jpg",
                            mimeType: "image/jpeg"
                        )
                    }
                }
            },
            to: url,
            method: .post,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success:
                print("이미지 업로드 성공!")
            case .failure(let error):
                print("이미지 업로드 실패: ", error.localizedDescription)
                if let data  = response.data, let body = String(data: data, encoding: .utf8) {
                    print("body: \(body)")
                }
            }
        }
    }
}
