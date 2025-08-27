//
//  HobbyProfileViewModel.swift
//  siso-ios
//
//  Created by 멘태 on 8/12/25.
//

enum InterestType: String, Identifiable, CaseIterable {
    case culture = "문화 & 예술"
    case exercise = "운동 & 야외활동"
    case hobby = "여가 & 취미"
    
    var id: String { self.rawValue }
}

class InterestProfileViewModel {
    private let cultures: [String] = ["#음악감상", "#사진촬영", "#서예", "#글쓰기", "#악기연주", "#영화감상", "#전시관람", "#클래식감상", "#노래부르기", "#댄스"]
    private let exercises: [String] = ["#등산", "#낚시", "#요가", "#골프", "#자전거", "#캠핑", "#수영", "#바둑", "#볼링", "#탁구", "#꽃꽂이", "#드라이브"]
    private let hobbies: [String] = ["#독서", "#베이킹", "#뜨개질", "#원예", "#여행","#맛집", "#명상", "#와인", "#요리", "#인테리어"]
    
    func getInterests(_ type: InterestType) -> [String] {
        switch type {
        case .culture:
            return cultures
        case .exercise:
            return exercises
        case .hobby:
            return hobbies
        }
    }
}
