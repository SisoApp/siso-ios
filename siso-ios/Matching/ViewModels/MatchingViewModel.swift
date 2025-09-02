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

@MainActor
public class MatchingViewModel: ObservableObject, HomeCardDelegate {
    public func getNowWatchingCardViewModel() -> CardViewModel? {
        return nowWatching
    }
    
    public var nowWatching: CardViewModel? = nil
    public var delegate: MatchingCoordinatorDelegate?
    
    public init(delegate: MatchingCoordinatorDelegate? = nil, cards: [CardViewModel]) {
        self.delegate = delegate
        self.cards = []
       
    }
    
    @Published public var cards: [CardViewModel] = []
    @Published var isProfileWriteDemanded: Bool = true
    @Published var errorMessage: String = ""
    
    
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
    
    func fetchCards() async {
        do {
            // 네트워크 매니저를 통해 프로필 데이터를 비동기적으로 가져옵니다.
            let newProfiles = try await NetworkManager.shared.getMatchingProfiles()
            
            // 받아온 MatchingProfile 데이터를 CardViewModel로 변환합니다.
            let newCards = newProfiles.map { profile in
                CardViewModel(profile: profile, delegate: self.delegate) // CardViewModel의 생성자가 profile을 받는다고 가정
            }
            
            // 기존 카드 목록에 새로운 카드를 추가합니다.
            self.cards.append(contentsOf: newCards)
            
            print("✅ \(newCards.count)개의 새 카드를 성공적으로 불러왔습니다.")
            
        } catch {
            // 오류 발생 시 콘솔에 로그를 남기고, UI에 표시할 에러 메시지를 설정합니다.
            print("🔴 카드 데이터를 불러오는 중 오류 발생: \(error.localizedDescription)")
            self.errorMessage = "프로필을 불러오는 데 실패했습니다. 잠시 후 다시 시도해주세요."
        }
    }
    
    func fetchMyProfile(completion: @escaping (UserProfileDTO) -> Void) async {
        do {
            try? await ProfileNetworkManager.shared.getCurrentUserProfile { profile in
                completion(profile)
            }
        }
    }
    
    func fetchMyInterests() async {
        try? await ProfileNetworkManager.shared.getInterests { interests in
            print(interests)
        }
    }
    
    func fetchMyImages() async {
        try? await ImageNetworkManager.shared.getMyImages()
    }
    
    func fetchMyVoice() async {
        try? await VoiceNetworkManager.shared.getMyVoice()
    }
}
