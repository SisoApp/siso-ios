
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
        #if DEBUG
           debugMenuView
               .padding()
               .background(.black.opacity(0.7))
               .cornerRadius(10)
               .padding(.bottom, 40)
           #endif
        }
        
        .onAppear() {
            callManager.delegate = delegate
        }
    }
#if DEBUG
@ViewBuilder
private var debugMenuView: some View {
    VStack(spacing: 8) {
        Text("🐞 Debug State Changer 🐞")
            .font(.caption.bold())
            .foregroundColor(.yellow)
        
        HStack(spacing: 8) {
            // 'To InCall' 버튼: connecting 또는 receiving 상태에서만 활성화
            Button("To InCall") {
                // 현재 상태에서 profile과 info를 가져와서 .inCall 상태로 강제 전환
                switch callManager.callState {
                case .connecting(let profile, let info):
                    callManager.changeStateForDebug(.inCall(profile: profile, info: info))
                case .receiving(let payload):
                    // receiving 상태는 profile 정보가 없으므로 임시 프로필을 생성해준다.
                    let tempProfile = MatchingProfile(
                        userId: payload.callerId,
                        nickname: payload.callerName,
                        age: 30, location: "서울", interests: [], introduce: "디버그용 임시 프로필",
                        imageUrls: ["https://picsum.photos/200"], voiceSampleUrl: nil, presenceStatus: .online
                    )
                    let myUserId = Int(KeyChainManager.shared.get(for: "myUserId") ?? "0")!
                    callManager.changeStateForDebug(.inCall(profile: tempProfile, info: CallInfoDto(from: payload, receiverId: myUserId)))
                default:
                    print("🐞 [Debug] Cannot switch to .inCall from current state: \(callManager.callState)")
                }
            }

            // 'To Assessment' 버튼: inCall 상태에서만 활성화
            Button("To Assessment") {
                // 현재 inCall 상태의 profile과 info를 가져와서 .assessment 상태로 전환
                if case .inCall(let profile, let info) = callManager.callState {
                    callManager.changeStateForDebug(.assessment(profile: profile, info: info))
                }
            }
            
            // 'To Idle' 버튼: 언제든지 누를 수 있음
            Button("To Idle") {
                callManager.changeStateForDebug(.idle)
            }
        }
        .font(.caption2)
        .buttonStyle(.borderedProminent)
        .tint(.gray)
    }
}
#endif
    
}

