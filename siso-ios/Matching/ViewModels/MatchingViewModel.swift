//
//  MatchingViewModel.swift
//  auth
//
//  Created by jdios on 8/13/25.
//

import SwiftUI
import AVFoundation
import model
import network

public class MatchingViewModel: ObservableObject, HomeCardDelegate {
    public func getNowWatchingCardViewModel() -> CardViewModel? {
        return nowWatching
    }
    
    public var nowWatching: CardViewModel? = nil
    public var delegate: MatchingCoordinatorDelegate?
    
    public init(delegate: MatchingCoordinatorDelegate? = nil, cards: [CardViewModel]) {
        self.delegate = delegate
        self.cards = [card1, card2, card3, card4]
    }
    
    @Published public var cards: [CardViewModel] = []
    @Published var isProfileWriteDemanded: Bool = true
    
    public func injectDelegateToCards() {
        print("main delegate")
        for card in cards {
            card.delegate = self.delegate
            card.homeCardDelegate = self
        }
        if let firstCard = cards.first, nowWatching == nil {
            nowWatching = firstCard
        }
    }
    public func cardViewModelDidRequestCall(on viewModel: CardViewModel) {
        self.nowWatching = viewModel
        print("👀 nowWatching이 \(viewModel.nickname)(으)로 업데이트 되었습니다.")
    }
    
    func fetchCards() {
        let newProfile: MatchingProfile = .sampleMessi
    }
    
    
    
}
extension MatchingViewModel {
    
    // 정적(static) 프로퍼티로 샘플 데이터를 만듭니다.
    // 이렇게 하면 MatchingViewModel.sample 로 어디서든 접근 가능합니다.
    public static var sample: MatchingViewModel {
        let viewModel = MatchingViewModel( delegate: nil, cards: [])
        
       

        // 생성된 카드들을 viewModel의 cards 배열에 추가합니다.
        viewModel.cards = [card1, card2, card3, card4]
        return viewModel
    }
}


// 여러 개의 CardViewModel 샘플을 생성합니다.
let card1 = CardViewModel(
    baseProfile: MatchingProfile.sampleMessi,
    nickname: "제인",
    age: 28,
    isOnline: true,
    interestTags: ["여행✈️", "사진", "카페투어"],
    profileImages: [
        // Lorem Picsum 서비스를 사용하여 실제 이미지를 가져옵니다. seed를 사용해 항상 같은 이미지가 나오도록 합니다.
        // 샘플 코드이므로 강제 언래핑(!)을 사용했지만, 실제 앱에서는 guard let으로 안전하게 처리해야 합니다.
        URL(string: "https://picsum.photos/seed/jane1/600/400")!,
        URL(string: "https://picsum.photos/seed/jane2/400/600")!,
        URL(string: "https://picsum.photos/seed/jane3/400/600")!
    ],
    // 실제 작동하는 샘플 오디오 파일 (출처: Google)
    voiceSample: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"),
    introduction: "안녕하세요! 좋은 인연을 찾고 있어요. 함께 맛있는 거 먹으러 다녀요.",
    location: "서울 마포구"
    
)

let card2 = CardViewModel(
    baseProfile: MatchingProfile.sampleMessi,
    nickname: "마이크",
    age: 32,
    isOnline: false,
    interestTags: ["운동💪", "영화감상", "음악"],
    profileImages: [
        URL(string: "https://picsum.photos/seed/mike1/400/600")!,
        URL(string: "https://picsum.photos/seed/mike2/400/600")!
    ],
    // 음성 샘플이 없는 경우 nil로 처리
    voiceSample: nil,
    introduction: "서울에서 직장 다니고 있습니다. 주말에 같이 운동하거나 영화 볼 분 찾아요!",
    location: "인천 중구"
)

let card3 = CardViewModel(
    baseProfile: MatchingProfile.sampleMessi,
    nickname: "클로이",
    age: 25,
    isOnline: true,
    interestTags: ["개발💻", "독서", "산책"],
    profileImages: [
        URL(string: "https://picsum.photos/seed/chloe1/400/600")!,
        URL(string: "https://picsum.photos/seed/chloe2/400/600")!,
        URL(string: "https://picsum.photos/seed/chloe3/400/600")!,
        URL(string: "https://picsum.photos/seed/chloe4/400/600")!
    ],
    voiceSample: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3"),
    introduction: "조용한 성격이지만 친해지면 말 많아요. 커피 한 잔 하면서 얘기 나눠요.",
    location: "서울 중구"
)

let card4 = CardViewModel(
    baseProfile: MatchingProfile.sampleMessi,
    nickname: "알렉스",
    age: 30,
    isOnline: true,
    interestTags: ["요리🍳", "캠핑", "강아지"],
    profileImages: [
        URL(string: "https://picsum.photos/seed/alex1/400/600")!
    ],
    voiceSample: nil,
    introduction: "직접 만든 요리를 대접하는 걸 좋아해요. 같이 캠핑가서 맛있는 거 해먹어요.",
    location: "서울 중구"
)

