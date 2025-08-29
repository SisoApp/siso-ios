//
//  ChatCoordinator.swift
//  siso-ios
//
//  Created by 김용해 on 8/27/25.
//

import SwiftUI


extension Coordinator: @preconcurrency ChatCoordinatorDelegate {
    // MARK: Page Conversion
    private func toIntegrationPage(_ page: ChatPage) -> IntegrationPage {
        switch page {
            case .main: return .main
            case .detail: return .detail
            case .notificationChat: return .notificationChat
        }
    }
    
    public func pushChat(_ page: chat.ChatPage) {
        chatPath.append(toIntegrationPage(page))
    }
}
