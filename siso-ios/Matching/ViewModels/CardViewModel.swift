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


public class CardViewModel: ObservableObject, Identifiable {
    
    // 1. Model을 let으로 소유 (Source of Truth)
    public let profile: MatchingProfile
    
    // 의존성 주입
    weak var delegate: MatchingCoordinatorDelegate?
    public weak var homeCardDelegate: HomeCardDelegate?

    // 2. Identifiable 준수를 위한 id
    public var id: Int { profile.id }

    // --- 뷰를 위한 계산 프로퍼티 ---
    public var nickname: String { profile.nickname }
    public var age: Int { profile.age }
    public var location: String { profile.location }
    public var interestTags: [String] { profile.interests }
    public var introduction: String { profile.introduce }
    
    public var profileImageURLs: [URL] {
        profile.imageUrls.compactMap { URL(string: $0) }
    }
    
    public var voiceSampleURL: URL? {
        guard let urlString = profile.voiceSampleUrl else { return nil }
        return URL(string: urlString)
    }
    
    // ViewModel이 직접 관리하는 상태
    @Published public var isOnline: Bool = true

    // --- Initializer ---
    public init(profile: MatchingProfile, delegate: MatchingCoordinatorDelegate? = nil) {
        self.profile = profile
        self.delegate = delegate
    }

    // --- Actions ---
    func call() {
        homeCardDelegate?.cardViewModelDidRequestCall(on: self)
        delegate?.changeMatchingToCall(opponentProfile: self.profile)
    }
    
    func chat() {
        print("chat button tapped")
    }
}
