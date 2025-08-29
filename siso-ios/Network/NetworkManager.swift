////
////  NetworkManager.swift
////  network
////
////  Created by jdios on 8/28/25.
////
//
//import Foundation
//import Alamofire
//import model
//
//public class NetworkManager {
//    public static let shared = NetworkManager()
//    private let keychain = KeyChainManager.shared
//    private let baseURL: String?
//    
//    public init() {
//        baseURL = Bundle.main.infoDictionary?["SERVER_URL"] as? String
//    }
//    // ✨ 1. 함수의 반환 타입을 명시합니다. -> [UserProfileServer]
//       public func getMatchingProfiles() async throws -> [MatchingProfile] {
//           guard let baseUrl = baseURL else {
//               throw AFError.invalidURL(url: "Base URL is not found.")
//           }
//           let urlString: String = baseUrl + "/api/users/filtered"
//           guard let url: URL = URL(string: urlString) else {
//               throw AFError.invalidURL(url: urlString)
//           }
//           guard let refreshToken = KeyChainManager.shared.get(for: "refreshToken") else {
//               // refreshToken이 없는 것은 인증 실패로 간주하는 것이 더 적절할 수 있습니다.
//               // 여기서는 예시로 invalidURL을 유지합니다.
//               throw AFError.explicitlyCancelled
//           }
//           
//           let headers: HTTPHeaders = [
//               "Authorization": "Bearer \(refreshToken)",
//               "Content-Type": "application/json"
//           ]
//           
//           // ✨ 2. AF.request 체인 마지막에 .serializingDecodable을 사용하고 await 키워드를 붙입니다.
//           let dataTask = AF.request(url,
//                                     method: .post,
//                                     parameters: parameters,
//                                     encoding: JSONEncoding.default,
//                                     headers: headers)
//                            .validate(statusCode: 200..<300)
//                            .serializingDecodable([MatchingProfile].self)
//
//           // ✨ 3. await를 사용하여 비동기 작업이 끝날 때까지 기다린 후, .value를 통해 결과를 추출합니다.
//           // 작업이 성공하면 value를 반환하고, 실패하면 do-catch 블록으로 에러가 전달됩니다.
//           let response = await dataTask.response
//           
//           switch response.result {
//           case .success(let profiles):
//               // ✅ 성공: 디코딩된 프로필 배열을 반환합니다.
//               print("✅ 프로필 목록 로딩 성공: \(profiles.count)개")
//               return profiles
//               
//           case .failure(let error):
//               // 🔴 실패: 에러를 출력하고, 함수를 호출한 곳으로 에러를 다시 던집니다.
//               print("🔴 프로필 목록 로딩 실패: \(error.localizedDescription)")
//               
//               // 디버깅을 위해 응답 바디를 출력합니다.
//               if let data = response.data, let body = String(data: data, encoding: .utf8) {
//                   print("Error Body: \(body)")
//               }
//               // 받은 에러를 그대로 호출부로 전달합니다.
//               throw error
//           }
//       }
//}
