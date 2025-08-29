//
//  CardViewModel.swift
//  siso-ios
//
//  Created by jdios on 8/15/25.
//

import SwiftUI
import AVFoundation
import model

public protocol HomeCardDelegate: AnyObject {
    func cardViewModelDidRequestCall(on viewModel: CardViewModel)
    func getNowWatchingCardViewModel() -> CardViewModel?
}


public class CardViewModel: ObservableObject, Identifiable  {
    weak var delegate: MatchingCoordinatorDelegate?
    
    public weak var homeCardDelegate: HomeCardDelegate?
    
    public init(baseProfile: MatchingProfile ,delegate: MatchingCoordinatorDelegate? = nil) {
        self.delegate = delegate
        self.baseProfile = baseProfile
    }
    
    public var baseProfile: MatchingProfile
    
    
    public let uuid: UUID = UUID()
    public var nickname: String = ""
    public var age: Int = 0
    public var isOnline: Bool = true
    public var interestTags: [String] = []
    public var profileImages: [URL] = []
    public var voiceSample: URL?
    public var introduction: String = ""
    public var location: String = ""
    // let backgroundImage: UIImage
    
    public init(baseProfile: MatchingProfile ,nickname: String, age: Int, isOnline: Bool, interestTags: [String], profileImages: [URL], voiceSample: URL?, introduction: String, location: String) {
        self.baseProfile = baseProfile
        self.nickname = nickname
        self.age = age
        self.isOnline = isOnline
        self.interestTags = interestTags
        self.profileImages = profileImages
        self.voiceSample = voiceSample
        self.introduction = introduction
        self.location = location
        
    }
    
    func call() { // 화면전환 -> 매너 뷰
       
        homeCardDelegate?.cardViewModelDidRequestCall(on: self)
        delegate?.changeMatchingToCall(opponentProfile: self.baseProfile)
        
    }
    
    func chat() {
        print("chat button tapped")
    }
}
extension CardViewModel {
    static let testModel: CardViewModel = .init(
        baseProfile: MatchingProfile.sampleMessi, nickname: "삼성전자회장이나야",
        age: 58,
        isOnline: true,
        interestTags: ["여행✈️", "사진", "카페투어"],
        profileImages: [
            URL(string: "https://picsum.photos/seed/jane1/600/400")!,
            URL(string: "https://picsum.photos/seed/jane1/600/400")!,
            URL(string: "https://picsum.photos/seed/jane2/400/600")!,
            URL(string: "https://picsum.photos/seed/jane3/400/600")!
        ],
        voiceSample: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"),
        introduction: "안녕하세요! 좋은 인연을 찾고 있어요. 함께 맛있는 거 먹으러 다녀요. SwiftUI는 재밌지만 가끔은 어렵네요. 그래도 열심히 공부하고 있습니다. 같이 코딩하실 분도 환영!",
        location: "인천 미추홀구"
    )
}
