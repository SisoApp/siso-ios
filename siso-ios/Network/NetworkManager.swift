import Foundation
import Alamofire
import model // 'MatchingProfile' 모델이 정의된 모듈

public class NetworkManager {
    public static let shared = NetworkManager()
    private let keychain = KeyChainManager.shared
    private let baseURL: String?
    
    public init() {
        baseURL = Bundle.main.infoDictionary?["SERVER_URL"] as? String
    }
    
    // 백엔드 API에 맞게 수정된 함수
    public func getMatchingProfiles(count: Int = 5) async throws -> [MatchingProfile] {
        guard let baseUrl = baseURL else {
            throw AFError.invalidURL(url: "Base URL is not found.")
        }
        
        // 1. 엔드포인트 경로 수정: "/matching"으로 변경
        let urlString: String = baseUrl + "/api/filter/matching" // ✅ 백엔드와 경로를 맞춰주세요. 보통 "/api" 접두사가 붙습니다.
        guard let url: URL = URL(string: urlString) else {
            throw AFError.invalidURL(url: urlString)
        }
        
        guard let refreshToken = KeyChainManager.shared.get(for: "refreshToken") else {
            // refreshToken이 없는 것은 인증 실패로 간주하는 것이 더 적절할 수 있습니다.
            // 여기서는 예시로 invalidURL을 유지합니다.
            throw AFError.explicitlyCancelled
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(refreshToken)",
            "Content-Type": "application/json"
        ]
        
        // 2. 쿼리 파라미터 설정: @RequestParam("count")에 해당
        let parameters: [String: Any] = [
            "count": count
        ]
        
        // 3. AF.request 호출부 수정
        let dataTask = AF.request(url,
                                  method: .get,
                                  parameters: parameters,
                                  encoding: URLEncoding.default,
                                  headers: headers)
        // ✨ 1. cURL 로그 출력
                   .cURLDescription { curl in
                       print("\n\n=============== 🚀 cURL Request ===============\n")
                       print(curl)
                       print("\n==============================================\n\n")
                   }
            .validate(statusCode: 200..<300)
            .serializingDecodable([MatchingProfile].self)
        
        let response = await dataTask.response
        
        switch response.result {
        case .success(let profiles):
            print("✅ 매칭 프로필 목록 로딩 성공: \(profiles.count)개")
            return profiles
            
        case .failure(let error):
            print("🔴 매칭 프로필 목록 로딩 실패: \(error.localizedDescription)")
            
            if let data = response.data, let body = String(data: data, encoding: .utf8) {
                print("Error Body: \(body)")
            }
            throw error
        }
    }
}
