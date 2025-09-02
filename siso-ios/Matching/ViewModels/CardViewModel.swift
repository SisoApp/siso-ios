//
//  CardViewModel.swift
//  siso-ios
//
//  Created by jdios on 8/15/25.
//

import SwiftUI
import AVFoundation
import model
import network

public protocol HomeCardDelegate: AnyObject {
    func cardViewModelDidRequestCall(on viewModel: CardViewModel)
    func getNowWatchingCardViewModel() -> CardViewModel?
}


public class CardViewModel: ObservableObject, Identifiable {
    private let sampleImgUrl: URL = URL(string: "https://imgur.com/a/24214AF")!
    
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
    public var location: String { profile.location ?? "비공개" }
    public var interestTags: [String] { profile.interests }
    public var introduction: String { profile.introduce ?? "" }
    
    public var profileImageURLs: [URL] {
       let urls =  profile.imageUrls.compactMap { URL(string: $0) }
        if urls.isEmpty {
            return [sampleImgUrl]
        }
        return urls
    }
    
    public var voiceSampleURL: URL? {
        guard let urlString = profile.voiceSampleUrl else { return nil }
        return URL(string: urlString)
    }
    
    // ViewModel이 직접 관리하는 상태
    public var presenceStatus: PresenceStatus {
        profile.presenceStatus
    }

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
