// CallProfileDto.swift

import Foundation

// 서버의 UserProfileDto와 일치 (이름을 CallProfileDto로 사용)
public struct CallProfileDto: Codable, Equatable {
    public var id = UUID()
    public let nickname: String
    public let age: Int
    public let location: String?
    public let interests: [String]
    public let profileImageUrl: String?
    
    // ✅ 여기에 변환을 위한 초기화 메서드를 추가합니다.
    /// MatchingProfile 객체로부터 CallProfileDto를 생성합니다.
    /// - Parameter profile: 변환할 원본 MatchingProfile 객체.
    public init(from profile: MatchingProfile) {
        self.nickname = profile.nickname
        self.age = profile.age
        self.location = profile.location
        self.interests = profile.interests
        self.profileImageUrl = profile.imageUrls.first // MatchingProfile의 이미지 URL 배열에서 첫 번째 이미지를 사용
    }
}
