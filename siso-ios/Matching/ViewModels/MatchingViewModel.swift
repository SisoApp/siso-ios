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
public class MatchingViewModel: ObservableObject, @preconcurrency HomeCardDelegate {
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
    /// 현재 로딩 중인지 여부를 나타내는 플래그 (중복 호출 방지용)
    private var isLoading: Bool = false
    
    /// 더 이상 불러올 데이터가 없는지 여부를 나타내는 플래그
    private var hasMoreData: Bool = true
    
    /// 불러오기 횟수
    private var fetchTries: Int = 0
    
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
    
    // HIGHLIGHT: fetchCards 함수 전체 수정
       func fetchCards() async {
           fetchTries += 1
           
           // 1. 로딩 중이거나, 더 이상 데이터가 없으면 함수를 즉시 종료 (핵심!)
           guard !isLoading, hasMoreData else {
               return
           }
           
           // 2. 로딩 시작
           isLoading = true
           
           do {
               // 3. 네트워크 매니저 호출 (페이지 번호와 사이즈 전달)
               let newProfiles = try await NetworkManager.shared.getMatchingProfiles()
               
               // 4. 받아온 데이터가 없으면, 더 이상 불러올 데이터가 없다고 표시
               if newProfiles.isEmpty {
                   hasMoreData = false
               } else {
                   // 5. 받아온 MatchingProfile을 CardViewModel로 변환
                   let newCards = newProfiles.map { CardViewModel(profile: $0, delegate: self.delegate) }
                   
                   // 6. 기존 카드 목록에 새로운 카드 추가
                   self.cards.append(contentsOf: newCards)
                   
                   print("\(fetchTries)번째 페이지 로딩입니다 . . .")
                   print("✅ \(newCards.count)개의 새 카드를 성공적으로 불러왔습니다.")
                   for item in newCards {
                       print("newCards Id is -----> \(item.profile.id)")
                   }
               }
               
           } catch {
               print("🔴 카드 데이터를 불러오는 중 오류 발생: \(error.localizedDescription)")
               self.errorMessage = "프로필을 불러오는 데 실패했습니다. 잠시 후 다시 시도해주세요."
           }
           
           // 8. 로딩 종료
           isLoading = false
       }
    
    func fetchMyProfile(completion: @escaping (UserProfileDTO) -> Void) async {
        do {
            try? await ProfileNetworkManager.shared.getCurrentUserProfile { profile in
                completion(profile)
            }
        }
    }
    
    func fetchMyInterests(completion: @escaping ([Interest]) -> Void) async {
        try? await ProfileNetworkManager.shared.getInterests { interests in
            completion(interests)
        }
    }
    
    func fetchMyImages(completion: @escaping ([ImageDTO]) -> Void) async {
        try? await ImageNetworkManager.shared.getMyImages(completion: { images in
            completion(images)
        })
    }
    
    func fetchMyVoice(completion: @escaping (VoiceDTO) -> Void) async {
        try? await VoiceNetworkManager.shared.getMyVoice(completion: { voice in
            completion(voice)
        })
    }
}
