//
//  VoiceNetwork.swift
//  network
//
//  Created by 멘태 on 8/29/25.
//

import Foundation
import Alamofire

public final actor VoiceNetworkManager: Sendable {
    public static let shared: VoiceNetworkManager = .init()
    private let baseUrl: String?
    
    public init() {
        self.baseUrl = Bundle.main.infoDictionary?["SERVER_URL"] as? String
    }
    
    public func getVoice() async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/voice-samples/user"
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
        .responseDecodable(of: VoiceResponseDTO.self) { response in
            switch response.result {
            case .success(let voice):
                print("녹음파일 조회 성공")
                print(voice.url)
                break
            case .failure(let error):
                print("녹음파일 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    
    public func uploadVoice() async throws {
        guard let baseUrl = baseUrl else { throw AFError.invalidURL(url: "base URL is not found.") }
        let urlString: String = baseUrl + "/api/voice-samples/user"
        guard let url: URL = URL(string: urlString) else { throw AFError.invalidURL(url: urlString) }
        
        guard let accessToken = KeyChainManager.shared.get(for: "accessToken") else {
            throw AFError.invalidURL(url: "accessToken -> nil")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
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
}
