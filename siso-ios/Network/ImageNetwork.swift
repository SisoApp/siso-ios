//
//  ImageNetwork.swift
//  network
//
//  Created by 멘태 on 8/29/25.
//

import UIKit
import Alamofire
import model

public final actor ImageNetworkManager: Sendable {
    public static let shared: ImageNetworkManager = .init()
    private let baseUrl: String?
    
    public init() {
        self.baseUrl = Bundle.main.infoDictionary?["SERVER_URL"] as? String
    }
    

    public func getMyImages() async throws -> [ImageDTO]? {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/images/me"
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
            .responseDecodable(of: [ImageDTO].self) { response in
                switch response.result {
                case .success(let images):
                    debugPrint("이미지 목록 조회 성공: \(images)")
                    continuation.resume(returning: images)
                case .failure(let error):
                    debugPrint("이미지 목록 조회 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    public func getUserImages(for userId: Int) async throws -> [ImageDTO]? {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/user/\(userId)"
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
            .responseDecodable(of: [ImageDTO].self) { response in
                switch response.result {
                case .success(let images):
                    debugPrint("이미지 목록 조회 성공: \(images)")
                    continuation.resume(returning: images)
                case .failure(let error):
                    debugPrint("이미지 목록 조회 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    private func fetchImages(_ url: URL, completion: @escaping ([ImageDTO]) -> Void) async throws {
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
            .responseDecodable(of: [ImageDTO].self) { response in
                switch response.result {
                case .success(let images):
                    debugPrint("이미지 목록 조회 성공: \(images)")
                case .failure(let error):
                    debugPrint("이미지 목록 조회 실패: \(error.localizedDescription)")
                }
            }
    }
    
    public func uploadImages(_ images: [UIImage]) async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/images/upload"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw AFError.invalidURL(url: "accessToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "multipart/form-data"
        ]
        
        print(url)
        print(images)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(
                multipartFormData: { multipartFormData in
                    for image in images {
                        let uuid: String = UUID().uuidString
                        
                        if let imageData = image.jpegData(compressionQuality: 1.0) {
                            multipartFormData.append(
                                imageData,
                                withName: "files",
                                fileName: "image\(uuid).jpg",
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
                    debugPrint("이미지 업로드 성공!")
                    continuation.resume()
                case .failure(let error):
                    debugPrint("이미지 업로드 실패: ", error.localizedDescription)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func removeImage(for id: Int) async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/images/\(id)"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw AFError.invalidURL(url: "accessToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url,
                   method: .delete,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success:
                debugPrint("이미지 제거 성공")
            case .failure(let error):
                debugPrint("이미지 제거 실패: \(error.localizedDescription)")
            }
        }
    }
}
