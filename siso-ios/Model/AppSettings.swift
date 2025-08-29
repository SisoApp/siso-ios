//
//  AppSettings.swift
//  siso-ios
//
//  Created by jdios on 8/28/25.
//

import Foundation
import SwiftUI
import Combine

// 앱의 전역 설정을 관리하는 클래스
@MainActor
public class AppSettings: ObservableObject {
    // @AppStorage를 사용하면 UserDefaults의 "tutorialHasBeenWatched" 키와 이 프로퍼티가 자동으로 동기화됩니다.
    // 값이 변경되면 @Published 덕분에 SwiftUI 뷰가 자동으로 업데이트됩니다.
    @AppStorage("tutorialHasBeenWatched") public var tutorialHasBeenWatched: Bool = false
    
    public init(){}
}
