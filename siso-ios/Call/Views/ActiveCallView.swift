
import SwiftUI
import model
import network
// 이 뷰는 CallManager의 상태를 보고 적절한 자식 뷰를 렌더링하는 '컨테이너' 역할을 합니다.
public struct ActiveCallView: View {
    // CallManager의 싱글턴 인스턴스를 @StateObject로 구독하여 상태 변화를 감지합니다.
    @EnvironmentObject var callManager: CallManager
    // 코디네이터와의 통신을 위한 delegate
    var delegate: CallCoordinatorDelegate
    
    public init(delegate: CallCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    public var body: some View {
        // CallManager의 callState 값에 따라 뷰를 전환합니다.
        ZStack {
            switch callManager.callState {
                
            case .idle:
                Color.clear
                    .onAppear {
                        print("Call state is idle. Dismissing call flow.")
                        delegate.dismissCallFlow()
                    }
                
            case .connecting(let profile, _):
                ConnectingView(receiverProfile: profile, delegate: delegate)
                
            case .receiving( _):
                EmptyView()
                
            case .inCall(let profile, _):
                let viewModel = CallViewModel(opponentProfile: profile)
                CallingView(inCallViewModel: viewModel, delegate: delegate)
            case .assessment(profile: let profile, info: let info):
                AfterCallAssessmentView(opponentProfile: profile, callInfo: info, delegate: delegate)
            }
        }
        
        .onAppear() {
            callManager.delegate = delegate
        }
    }
}
