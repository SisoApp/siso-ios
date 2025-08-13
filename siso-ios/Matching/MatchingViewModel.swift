//
//  MatchingViewModel.swift
//  auth
//
//  Created by jdios on 8/13/25.
//

import SwiftUI
/*
 매칭 화면에 뿌려져야 하는 것
 상대방 매칭 카드 뷰
 - 이미지 (배경)
 - 닉네임
 - 음성 샘플 (Optional)
 - 관심사 태그
 - 한줄 소개
 - 전화 걸기 버튼
 
 따라서 매칭 뷰 모델은 카드 뷰에 해당하는 데이터를 가지고 있어야 한다.
 매칭 뷰 모델은 모델을 엮어서 하나의 데이터셋으로 엮을 수 있어야 한다.
 매칭 뷰 모델은 네트워크 모듈을 다루어야 한다
 매칭 뷰 모델은 무한 스크롤처럼 카드 뷰가 특정 범위를 넘어가면 백엔드에서 데이터를 요청해와야한다
 
 매칭 뷰 모델은 카드 뷰 모델을 가지고 있어야한다.
 
 */

final class MatchingViewModel: ObservableObject {

    @Published var cards: [CardViewModel] = []
    
}

final class CardViewModel: ObservableObject {
    
    let nickname: String
    let age: Int
    var isOnline: Bool
    let profileImages: [URL]
    let voiceSample: URL?
    let introduction: String
    
    init(nickname: String, age: Int, isOnline: Bool, profileImages: [URL], voiceSample: URL?, introduction: String) {
        self.nickname = nickname
        self.age = age
        self.isOnline = isOnline
        self.profileImages = profileImages
        self.voiceSample = voiceSample
        self.introduction = introduction
    }
    
    func call() {
        // 호감 표시로 대체할까?
        // 화면 전환이 가능해야 한다.
        print("call button tapped")
        
    }
    
    
    
    
}



