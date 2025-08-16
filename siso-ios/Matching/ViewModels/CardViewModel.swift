//
//  CardViewModel.swift
//  siso-ios
//
//  Created by jdios on 8/15/25.
//

import SwiftUI
import AVFoundation


final class CardViewModel: ObservableObject, Identifiable {
    let uuid: UUID = UUID()
    var nickname: String = ""
    var age: Int = 0
    var isOnline: Bool = true
    var interestTags: [String] = []
    var profileImages: [URL] = []
    var voiceSample: URL?
    var introduction: String = ""
    var location: String = ""
   // let backgroundImage: UIImage
    
    init(nickname: String, age: Int, isOnline: Bool, interestTags: [String], profileImages: [URL], voiceSample: URL?, introduction: String, location: String) {
        self.nickname = nickname
        self.age = age
        self.isOnline = isOnline
        self.interestTags = interestTags
        self.profileImages = profileImages
        self.voiceSample = voiceSample
        self.introduction = introduction
        self.location = location
        
    }
    
    func call() { // 화면전환 필요함
        print("call button tapped")
        
    }
    
    func chat() {
        print("chat button tapped")
    }

    
    
    
    
}
