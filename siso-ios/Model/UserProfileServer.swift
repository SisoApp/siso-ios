//
//  UserProfile.swift
//  siso-ios
//
//  Created by 멘태 on 8/12/25.
//

import Foundation

public struct UserProfileServer: Equatable, Identifiable {
    public let id = UUID()
    
    public let nickname: String // 닉네임
    public let sex: String // 성별
    public var age: Int // 나이
    public var height: Int // 키
    public var interestTags: [String] // 취미
    public var profileImageUrls: [String] // 프로필 사진
    public var introduce: String // 자기소개
    public var contact: String // 선호하는 연락 수단
    public var drinkingCapacity: String // 주량
    public var isSmoke: Bool // 흡연 여부
    public var location: String
    
    /// 리오넬 메시를 테마로 한 샘플 프로필 데이터
    public static let sampleMessi: UserProfileServer = .init(
        nickname: "리오넬 메시",
        sex: "남자",
        age: 37,
        height: 169,
        interestTags: ["구토댄스", "메슬렁대기", "발롱도르 받기"], // 실제 키는 169~170cm로 알려져 있습니다.
        profileImageUrls:[ "https://picsum.photos/seed/messi/400/600"], // 'messi'라는 시드 값으로 고정된 랜덤 이미지를 가져옵니다.
        introduce: "안녕하세요! 축구와 가족을 사랑하는 평범한 사람입니다. 경기장 밖에서는 조용하지만, 좋은 사람들과 함께하는 맛있는 식사와 대화를 즐겨요. 함께 마테차 한잔하실 분 찾습니다. 🧉",
        contact: "인스타그램 DM",
        drinkingCapacity: "와인 한 두 잔 🍷",
        isSmoke: false,
        location: "아르헨티나 부에노스아이레스"
    )
}
