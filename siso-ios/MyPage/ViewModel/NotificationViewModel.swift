//
//  NotificationViewModel.swift
//  mypage
//
//  Created by 멘태 on 8/20/25.
//
import Combine

enum NotificationSetting: String, Identifiable, CaseIterable {
    case new = "새로운 인연 요청 알림"
    case missed = "내 프로필 부재중 알림"
    case marketing = "마케팅 알림"
    
    var id: String { self.rawValue }
}

class NotificationViewModel: ObservableObject {
    @Published var agreements: [NotificationSetting: Bool] = .init()
}
