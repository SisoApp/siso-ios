import SwiftUI
import Foundation
import Combine
import auth
import profile
import matching
import network
import mypage
import model
import call
import chat

public enum IntegrationPage {
    
    // Auth
    case login
    case accept
    case welcome
    
    // Matching
    case home
    case tutorial
    
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
    case voice
    
    // MyPage
    case my
    case setting
    case notification
    
    // Call
    case manner(opponentProfile: UserProfileServer)
    // connecting 케이스는 상대방 프로필 정보가 필요합니다.
    case activeCall // 연관값이 필요 없습니다. ActiveCallView가 CallManager에서 정보를 가져옵니다.
    case reportFeedbackPopup
    // Chat
    case main
    case detail
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
    var locationViewModel: LocationViewModel
    var nowWatching: CardViewModel?
    
    public init(userProfile: UserProfile, matchingViewModel: MatchingViewModel, authViewModel: SocialLoginView.LoginViewModel, locationViewModel: LocationViewModel) {
        self.userProfile = userProfile
        self.matchingViewModel = matchingViewModel
        self.authViewModel = authViewModel
        self.locationViewModel = locationViewModel
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
            TabView {
                MatchingMainView(viewModel: matchingViewModel, delegate: self)
                    .navigationBarBackButtonHidden(true)
                    .tabItem {
                        Label("둘러보기", systemImage: "house")
                    }

                ChatMainView()
                    .navigationBarBackButtonHidden(true)
                    .tabItem {
                        Label("대화", systemImage: "ellipsis.message")
                    }

                MyPageView(delegate: self)
                    .navigationBarBackButtonHidden(true)
                    .tabItem {
                        Label("내 정보", systemImage: "person")
                    }
            }
            .tint(Color.Siso.Primary._100)
        case .tutorial:
            TutorialViews(selectedTabIndex: 0, delegate: self)
                .navigationBarBackButtonHidden(true)
        
            
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
        case .voice:
            RecordProfileView(delegate: self, currentPage: .constant(.basic), userProfile: userProfile, mode: .edit)
            
            // MyPage
        case .my:
            MyPageView(delegate: self)
        case .setting:
            SettingView(delegate: self)
        case .notification:
            NotificationView(delegate: self)
            
            // Call
        case .manner:
            CallMannerView(opponentProfile: UserProfileServer.sampleMessi, delegate: self)
                .navigationBarBackButtonHidden(true)
        case .connecting(let opponentProfile):
            ConnectingView(opponentProfile: opponentProfile, delegate: self)
                .navigationBarBackButtonHidden(true)
        case .calling(let viewModel):
            CallingView(inCallViewModel: viewModel,
                        delegate: self)
            .navigationBarBackButtonHidden(true)
        case .incomingCall(let info):
            IncommingCallView(callInfo: info,
                              delegate: self)
            .navigationBarBackButtonHidden(true)
        case .reportFeedbackPopup:
            ReportFeedBackView(delegate: self)
                .navigationBarBackButtonHidden(true)
            
        case .main:
            ChatMainView()
        case .detail:
            ChatMainView.ChatDetailView(chat: ChatMainView.RecentChat(userName: "세종대왕", icon: "person.circle.fill", time: Date().addingTimeInterval(-9000), hasMessages: true))
        }
    }
    
    
}

extension IntegrationPage: Equatable, Hashable {
    // Equatable 프로토콜 구현 (==)
    public static func == (lhs: IntegrationPage, rhs: IntegrationPage) -> Bool {
        switch (lhs, rhs) {
        case (.login, .login), (.accept, .accept), (.home, .home), (.manner, .manner), (.reportFeedbackPopup, .reportFeedbackPopup):
            return true // 연관값 없는 케이스들
        case (.connecting(let lhsProfile), .connecting(let rhsProfile)):
            return lhsProfile.id == rhsProfile.id // id로 비교
        case (.calling(let lhsVM), .calling(let rhsVM)):
            return lhsVM === rhsVM // ViewModel은 클래스이므로 인스턴스 자체를 비교 (===)
        case (.incomingCall(let lhsInfo), .incomingCall(let rhsInfo)):
            return lhsInfo.id == rhsInfo.id // 정보의 고유 ID로 비교
        default:
            return false // 다른 모든 조합은 false
        }
    }
    
    // Hashable 프로토콜 구현 (hash)
    public func hash(into hasher: inout Hasher) {
        switch self {
            // Auth
        case .login:
            hasher.combine("login")
        case .accept:
            hasher.combine("accept")
        case .welcome:
            hasher.combine("welcome")
            
            // Matching
        case .home:
            hasher.combine("home")
        case .tutorial:
            hasher.combine("tutorial")
       
            
            // Profile
        case .complete:
            hasher.combine("complete")
        case .location:
            hasher.combine("location")
        case .religion:
            hasher.combine("religion")
        case .smoke:
            hasher.combine("smoke")
        case .drink:
            hasher.combine("drink")
        case .personality:
            hasher.combine("personality")
        case .meeting:
            hasher.combine("meeting")
        case .profile:
            hasher.combine("profile")
        case .signUp:
            hasher.combine("signUp")
        case .interest:
            hasher.combine("interest")
        case .voice:
            hasher.combine("voice")
            
            // MyPage
        case .my:
            hasher.combine("my")
        case .setting:
            hasher.combine("setting")
        case .notification:
            hasher.combine("notification")
            
            // Call (연관값이 있는 경우)
        case .manner(let opponentProfile):
            hasher.combine("manner")
            hasher.combine(opponentProfile.id)
            
        case .connecting(let opponentProfile):
            hasher.combine("connecting")
            hasher.combine(opponentProfile.id) // 연관값의 고유 식별자를 해싱
        case .calling(let viewModel):
            hasher.combine("calling")
            hasher.combine(viewModel.id) // ViewModel의 고유 식별자를 해싱
        case .incomingCall(let callInfo):
            hasher.combine("incomingCall")
            hasher.combine(callInfo.id) // callInfo의 고유 식별자를 해싱
        case .reportFeedbackPopup:
            hasher.combine("reportFeedbackPopup")
        case .main:
            hasher.combine("main")
        case .detail:
            hasher.combine("detail")
        }
    }
}
#Preview {
    // Preview용 UserProfile
    @Previewable @StateObject var coordinator = Coordinator(userProfile: UserProfile.empty, matchingViewModel: MatchingViewModel.sample, authViewModel: SocialLoginView.LoginViewModel(), locationViewModel: LocationViewModel())
    
    // TabView 테스트
    NavigationStack(path: $coordinator.path) {
        coordinator.build(.home)
    }
}
