//
//  SettingViewModel.swift
//  mypage
//
//  Created by 멘태 on 9/2/25.
//

import Foundation
import network

public extension SettingView {
    @MainActor
    class SettingViewModel {
        private let loginNetworkManager: LoginNetworkManager = .init()
        
        func logout(completion: () -> Void) async {
            await loginNetworkManager.logout()
            completion()
        }
    }
}
