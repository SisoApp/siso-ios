import SwiftUI
import Foundation
import auth
import profile
import matching
import network

public enum IntegrationPage: Hashable {
    // Auth
    case login
    case accept
    case welcome
    
    // Matching
    case home
    case beCalled
    case chat
    case contacting
    case calling
    
    // Profile
    case basic
    case interest
    case image
    case introduce
    case record
    case complete
}

@MainActor
public class Coordinator: ObservableObject {
    @Published public var stackID: UUID = UUID()
    @Published public var path: NavigationPath = NavigationPath()
    @Published public var profileSheet: ProfileSheet?
    // ✅ 1. 어떤 '종류'의 통화 모달을 띄울지 결정 (사용자의 CallPage enum 사용)
    @Published public var activeCallPage: CallPage?
    
    // ✅ 2. 통화 모달에 필요한 '데이터'를 저장
    @Published public var activeCallInfo: IncomingCallInfo?
    
    // ✅ 3. 통화 후 팝업을 위한 Sheet 상태 (사용자의 CallSheet enum 사용, 기존과 동일)
    @Published public var callSheet: CallSheet?
    private let callManager = CallManager.shared
    private var cancellables = Set<AnyCancellable>()
    // 내 프로파일
    var userProfile: UserProfile
    var matchingViewModel: MatchingViewModel
    var authViewModel: SocialLoginView.LoginViewModel
    
    public init(userProfile: UserProfile, matchingViewModel: MatchingViewModel, authViewModel: SocialLoginView.LoginViewModel) {
        self.userProfile = userProfile
        self.matchingViewModel = matchingViewModel
        self.authViewModel = authViewModel
        self.matchingViewModel.delegate = self
    }
    
    // ** Common
    public func pop() {
        path.removeLast()
    }
    
    public func popToRoot() {
        path.removeLast(path.count - 1)
    }

    @ViewBuilder
    public func build(_ page: IntegrationPage) -> some View {
        switch page {
        // Auth
        case .login:
            SocialView(delegate: self)
        case .accept:
            AcceptanceView(delegate: self)
        case .welcome:
            WelcomeView(delegate: self)
        // Matching
        case .home:
            MatchingMainView(viewModel: matchingViewModel, delegate: self)
                .navigationBarBackButtonHidden(true)
        case .beCalled:
            if let nowWatching = matchingViewModel.nowWatching {
                MatchingCalledView(cardViewModel: nowWatching)
                    .navigationBarBackButtonHidden(true)
            }
        case .chat:
            EmptyView()
        case .contacting:
            if let nowWatching = matchingViewModel.nowWatching {
                MatchingContactingView(cardViewModel: nowWatching)
                    .navigationBarBackButtonHidden(true)
            }
        case .calling:
            if let nowWatching = matchingViewModel.nowWatching {
                MatchingCallingView(cardViewModel: nowWatching, callManager: CallManager())
                    .navigationBarBackButtonHidden(true)
            }
        // Profile
        case .basic:
            BasicProfileView(delegate: self, userProfile: userProfile)
        case .interest:
            InterestProfileView(delegate: self, userProfile: userProfile)
        case .image:
            ImageProfileView(delegate: self, userProfile: userProfile)
        case .introduce:
            IntroduceProfileView(delegate: self, userProfile: userProfile)
        case .record:
            RecordProfileView(delegate: self, userProfile: userProfile)
        case .complete:
            CompleteProfileView(delegate: self)
        }
    }
}
