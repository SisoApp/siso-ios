import SwiftUI
import Foundation
import auth
import profile
import matching
import network
import call
import model

extension Coordinator: @preconcurrency CallCoordinatorDelegate {
    
    
    // ** Page Conversion
    private func toIntegrationPage(_ page: CallPage) -> IntegrationPage {
        switch page {
            
        case .manner(let opponentProfile):
            return .manner(opponentProfile: opponentProfile)
    
        case .activeCall:
            return .activeCall
            
//        case .connecting(let opponentProfile):
//            return .connecting(opponentProfile: opponentProfile)
//            
//        case .calling(let viewModel):
//            return .calling(viewModel: viewModel)
//            
//        case .incomingCall(let callInfo):
//            return .incomingCall(callInfo: callInfo)
//            
        case .reportFeedbackPopup:
            return .reportFeedbackPopup
        }
    }
    
    
    public func pushCall(_ call: call.CallPage) {
        path.append(toIntegrationPage(call))
    }
    
    
    @ViewBuilder
    public func build(sheet: CallSheet) -> some View {
        switch sheet {
        case .report(let opponentProfile) :
            ReportPopupView(opponentProfile: opponentProfile)
            
        }
    }
}
