import SwiftUI
import Foundation
import auth
import profile
import matching
import network
import mypage

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
    case complete
    case location
    case religion
    case smoke
    case drink
    case personality
    case meeting
    case profile
    case signUp
    case interest
    
    // MyPage
    case my
    case setting
    case notification
}

@MainActor
public class Coordinator: ObservableObject {
    @Published public var stackID: UUID = UUID()
    @Published public var path: NavigationPath = NavigationPath()
    @Published public var profileSheet: ProfileSheet?
    @Published public var matchingSheet: MatchingSheet?
    
    var userProfile: UserProfile
    var matchingViewModel: MatchingViewModel
    var authViewModel: SocialLoginView.LoginViewModel
    var locationViewModel: LocationViewModel
    
    public init(userProfile: UserProfile, matchingViewModel: MatchingViewModel, authViewModel: SocialLoginView.LoginViewModel, locationViewModel: LocationViewModel) {
        self.userProfile = userProfile
        self.matchingViewModel = matchingViewModel
        self.authViewModel = authViewModel
        self.locationViewModel = locationViewModel
        self.matchingViewModel.delegate = self
        CallManager.shared.delegate = self
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
        case .complete:
            CompleteProfileView(delegate: self)
        case .location:
            LocationProfileView(delegate: self, userProfile: userProfile, viewModel: locationViewModel)
        case .religion:
            ReligionProfileView(delegate: self, userProfile: userProfile)
        case .smoke:
            SmokeProfileView(delegate: self, userProfile: userProfile)
        case .drink:
            DrinkProfileView(delegate: self, userProfile: userProfile)
        case .personality:
            PersonalityProfileView(delegate: self, userProfile: userProfile)
        case .meeting:
            MeetingProfileView(delegate: self, userProfile: userProfile)
        case .profile:
            ProfileView(delegate: self, userProfile: userProfile)
        case .signUp:
            SignUpProfileView(delegate: self, userProfile: userProfile)
        case .interest:
            InterestProfileView(delegate: self, userProfile: userProfile)
            
        // MyPage
        case .my:
            MyPageView(delegate: self)
        case .setting:
            SettingView(delegate: self)
        case .notification:
            NotificationView(delegate: self)
        }
    }
}
