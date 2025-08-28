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
    case manner
    // connecting 케이스는 상대방 프로필 정보가 필요합니다.
    case connecting(opponentProfile: UserProfileServer)
    // calling 케이스는 InCallViewModel이 필요합니다.
    case calling(viewModel: CallViewModel)
    // incomingCall 케이스는 IncomingCallInfo가 필요합니다.
    case incomingCall(callInfo: IncomingCallInfo)
    case reportFeedbackPopup
    // Chat
    case main
    case detail
    case notificationChat
}

@MainActor
public class Coordinator: ObservableObject {
    @Published public var stackID: UUID = UUID()
    
    // MARK: - Navigation Paths
    @Published public var path: NavigationPath = NavigationPath() // 인증(Auth) 흐름용
    @Published public var matchingPath = NavigationPath()
    @Published public var chatPath = NavigationPath()
    @Published public var myPagePath = NavigationPath()
    
    @Published public var profileSheet: ProfileSheet?
    @Published public var matchingSheet: MatchingSheet?
    @Published public var callPage: CallPage?
    @Published public var callSheet: CallSheet?
    @Published public var activeCallInfo: IncomingCallInfo?
    private let callManager = CallManager.shared
    private var cancellables = Set<AnyCancellable>()
    // 튜토리얼 시청 여부
    var tutorialHasBeenWatched: Bool {
        UserDefaults.standard.bool(forKey: "tutorialHasBeenWatched")
    }
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
        path = NavigationPath()
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
                NavigationStack(path: Binding(get: { self.matchingPath }, set: { self.matchingPath = $0 })) {
                    MatchingMainView(viewModel: matchingViewModel, delegate: self)
                        .navigationBarBackButtonHidden(true)
                        .navigationDestination(for: IntegrationPage.self) { page in
                            AnyView(self.build(page))
                        }
                }
                .tabItem {
                    Label("둘러보기", systemImage: "house")
                }
                
                NavigationStack(path: Binding(get: { self.chatPath }, set: { self.chatPath = $0 })) {
                    ChatMainView(delegate: self)
                        .navigationBarBackButtonHidden(true)
                        .navigationDestination(for: IntegrationPage.self) { page in
                            AnyView(self.build(page))
                        }
                }
                .tabItem {
                    Label("대화", systemImage: "ellipsis.message")
                }
                
                NavigationStack(path: Binding(get: { self.myPagePath }, set: { self.myPagePath = $0 })) {
                    MyPageView(delegate: self)
                        .navigationBarBackButtonHidden(true)
                        .navigationDestination(for: IntegrationPage.self) { page in
                            AnyView(self.build(page))
                        }
                }
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
        case .connecting(_):
            
            CallMannerView(opponentProfile: UserProfileServer.sampleMessi, delegate: self)
        case .calling(let viewModel):
            CallingView(inCallViewModel: viewModel,
                        delegate: self)
        case .incomingCall(let info):
            IncommingCallView(callInfo: info,
                              delegate: self)
        case .reportFeedbackPopup:
            ReportFeedBackView(delegate: self)
            // Chat
        case .main:
            ChatMainView(delegate: self)
        case .detail:
            ChatMainView.ChatDetailView(chat: ChatMainView.RecentChat(userName: "세종대왕", icon: "person.circle.fill", time: Date().addingTimeInterval(-9000), hasMessages: true))
        case .notificationChat:
            NotificationChatView()
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
        case .manner:
            hasher.combine("manner")
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
            // Chat
        case .main:
            hasher.combine("main")
        case .detail:
            hasher.combine("detail")
        case .notificationChat:
            hasher.combine("notificationChat")
        }
    }
}
#Preview {
    // Preview용 UserProfile
    @Previewable @StateObject var coordinator = Coordinator(userProfile: UserProfile.empty, matchingViewModel: MatchingViewModel.sample, authViewModel: SocialLoginView.LoginViewModel(), locationViewModel: LocationViewModel())
    
    // TabView 테스트
    coordinator.build(.home)
}
