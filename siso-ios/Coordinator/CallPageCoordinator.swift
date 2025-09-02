import SwiftUI
import Foundation
import auth
import profile
import matching
import network
import call
import model

extension Coordinator: @preconcurrency CallCoordinatorDelegate {
    // ✅ "인연 이어가기" 선택 시 호출될 새로운 함수
    public func popToRootAndGoToChat() {
        // 1. 모든 내비게이션 스택을 초기화 (홈으로 돌아감)
        matchingPath = NavigationPath()
        chatPath = NavigationPath()
        myPagePath = NavigationPath()
        
        // 2. 채팅 탭으로 전환
        selectedTab = 1 // 탭 인덱스가 1이라고 가정
        
        // 3. 채팅 탭의 NavigationStack에 채팅방(detail)을 push
        //    (채팅방을 식별할 정보가 필요. 여기서는 opponent ID를 사용한다고 가정)
        //    ChatRoom 모델이 필요합니다.
        
        chatPath.append(IntegrationPage.main)
    }
    
    
    public func callToHome() {
        matchingPath.append(IntegrationPage.home)
    }
    
    
    
    // ** Page Conversion
    private func toIntegrationPage(_ page: CallPage) -> IntegrationPage {
        switch page {
            
        case .manner(let opponentProfile):
            return .manner(opponentProfile: opponentProfile)
            
        case .activeCall:
            return .activeCall
            
            
        case .reportFeedbackPopup:
            return .reportFeedbackPopup
        }
    }
    
    
    public func pushCall(_ call: call.CallPage) {
        print("Push Call Page \(call)")
        matchingPath.append(toIntegrationPage(call))
    }
    
    
    @ViewBuilder
    public func build(sheet: CallSheet) -> some View {
        switch sheet {
        case .report(let opponentProfile) :
            ReportPopupView(opponentProfile: opponentProfile)
            
        }
    }
}
