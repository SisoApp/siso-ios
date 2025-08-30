import Foundation

// 서버의 MatchingProfileResponseDto와 1:1로 매핑되는 구조체
public struct MatchingProfile: Codable, Equatable, Identifiable {
    
    // 1. 서버에서 내려주는 고유 ID를 사용합니다.
    public let userId: Int
    
    // Identifiable 프로토콜을 준수하기 위한 id 프로퍼티
    // 서버의 userId를 그대로 사용합니다.
    public var id: Int {
        return userId
    }
    
    // 2. DTO와 필드 이름을 일치시킵니다.
    public let nickname: String
    public let age: Int
    public let location: String
    public let interests: [String]      // interestTags -> interests
    public let introduce: String
    public let imageUrls: [String]      // profileImageUrls -> imageUrls
    
    // 3. DTO에 새로 추가된 필드를 반영합니다. (옵셔널로 처리)
    public let voiceSampleUrl: String?
    
    // 4. DTO에 없는 필드들은 제거합니다.
    // sex, height, contact, drinkingCapacity, isSmoke 등

    
    /// 리오넬 메시를 테마로 한 샘플 프로필 데이터 (새로운 구조에 맞게 수정)
    public static let sampleMessi: MatchingProfile = .init(
        userId: 10, // 샘플용 고유 ID
        nickname: "리오넬 메시",
        age: 37,
        location: "아르헨티나 부에노스아이레스",
        interests: ["구토댄스", "메슬렁대기", "발롱도르 받기"],
        introduce: "안녕하세요! 축구와 가족을 사랑하는 평범한 사람입니다. 경기장 밖에서는 조용하지만, 좋은 사람들과 함께하는 맛있는 식사와 대화를 즐겨요. 함께 마테차 한잔하실 분 찾습니다. 🧉",
        imageUrls: ["https://picsum.photos/seed/messi/400/600"],
        voiceSampleUrl: nil // 샘플 데이터에서는 nil 처리
    )
}
