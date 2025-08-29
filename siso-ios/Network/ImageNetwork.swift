//
//  ImageNetwork.swift
//  network
//
//  Created by 멘태 on 8/29/25.
//

import UIKit
import Alamofire

public final actor ImageNetworkManager: Sendable {
    public static let shared: ImageNetworkManager = .init()
    private let baseUrl: String?
    
    public init() {
        self.baseUrl = Bundle.main.infoDictionary?["SERVER_URL"] as? String
    }
    
    public func uploadImages(_ images: [UIImage]) async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/images/upload"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        print(urlString)
        
        guard let refreshToken = KeyChainManager.shared.get(for: "refreshToken") else {
            throw AFError.invalidURL(url: "refreshToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(refreshToken)",
            "Content-Type": "multipart/form-data"
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
