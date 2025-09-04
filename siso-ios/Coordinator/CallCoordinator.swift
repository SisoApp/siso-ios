import SwiftUI
import Foundation
import auth
import profile
import matching
import network
import call
import model

extension Coordinator: @preconcurrency CallCoordinatorDelegate {
    public func openReportSheet(_ sheet: call.CallSheet) {
        self.callSheet = sheet
    }
    
    // ✅ "인연 이어가기" 선택 시 호출될 새로운 함수
    public func popToRootAndGoToChat() {
        selectedTab = 1 // 탭 인덱스가 1이라고 가정
        matchingPath = NavigationPath()
        chatPath = NavigationPath()
        
        
       
      
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
