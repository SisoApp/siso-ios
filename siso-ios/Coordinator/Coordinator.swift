import SwiftUI
import Foundation
import Combine
import auth
import profile
import matching
import network
import model
import call

public enum IntegrationPage: Hashable {
    // Auth
    case login
    case accept
    case welcome
    
    // Matching
    case home
    case tutorial
    case profileWriteDemand
    
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
    @Published public var matchingSheet: MatchingSheet?
    @Published public var callPage: CallPage?
    @Published public var callSheet: CallSheet?
    @Published public var activeCallInfo: IncomingCallInfo?
    private let callManager = CallManager.shared
    private var cancellables = Set<AnyCancellable>()
    // 내 프로파일
    var userProfile: UserProfile
    var matchingViewModel: MatchingViewModel
    var authViewModel: SocialLoginView.LoginViewModel
    var nowWatching: CardViewModel?
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
        case .tutorial:
            TutorialViews(selectedTabIndex: 0, delegate: self)
                .navigationBarBackButtonHidden(true)
        case .profileWriteDemand:
            ProfileDemandingView(delegate: self, matchingViewModel: matchingViewModel)
                .navigationBarBackButtonHidden(true)
       
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