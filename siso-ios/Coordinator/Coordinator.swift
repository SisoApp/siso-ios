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

// ✨ 1. Delegate 프로토콜을 @MainActor와 : AnyObject로 올바르게 정의합니다.
@MainActor
public protocol MatchingCoordinatorDelegate: AnyObject {
    func push(page: IntegrationPage)
    func pop()
    func popToRoot()
    func present(sheet: MatchingSheet)
    func changeToAuth() // ✨ 추가: 로그아웃 등 인증 플로우로 돌아갈 때 사용
}


@MainActor
public class Coordinator: ObservableObject, MatchingCoordinatorDelegate {
    @Published public var stackID: UUID = UUID()
    
    // MARK: - Navigation Paths
    @Published public var path: NavigationPath = NavigationPath() // 인증/로그인 플로우 용
    @Published public var matchingPath = NavigationPath()
    @Published public var chatPath = NavigationPath()
    @Published public var myPagePath = NavigationPath()
    @Published public var selectedTab: Int = 0
    
    // MARK: - Sheet & Call Properties
    @Published public var profileSheet: ProfileSheet?
    @Published public var matchingSheet: MatchingSheet?
    @Published public var callPage: CallPage?
    @Published public var callSheet: CallSheet?
    @Published public var activeCallInfo: IncomingCallInfo?
    @Published public var afterCallSheetProfile: UserProfileServer?
    
    private let callManager = CallManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - ViewModels & State
    var userProfile: UserProfile
    var matchingViewModel: MatchingViewModel
    var authViewModel: SocialLoginView.LoginViewModel
    var locationViewModel: LocationViewModel
    var nowWatching: CardViewModel?
    var appSettings: AppSettings = AppSettings()
    
    public init(userProfile: UserProfile, matchingViewModel: MatchingViewModel, authViewModel: SocialLoginView.LoginViewModel, locationViewModel: LocationViewModel) {
        self.userProfile = userProfile
        self.matchingViewModel = matchingViewModel
        self.authViewModel = authViewModel
        self.locationViewModel = locationViewModel
        self.matchingViewModel.delegate = self
        subscribeToCallManagerEvents()
    }
    
    private func subscribeToCallManagerEvents() {
        callManager.showAfterCallPopupPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] opponentProfile in
                print("📞 Coordinator received event to show assessment sheet.")
                self?.afterCallSheetProfile = opponentProfile
            }
            .store(in: &cancellables)
    }

    // MARK: - Delegate Method Implementations (여기에 모든 구현을 모읍니다)
    
    // ✨ 2. Delegate가 요구하는 모든 메서드를 여기에 깔끔하게 구현합니다.
    public func push(page: IntegrationPage) {
        print("Pushing page: \(page) on tab \(selectedTab)")
        switch selectedTab {
        case 0: matchingPath.append(page)
        case 1: chatPath.append(page)
        case 2: myPagePath.append(page)
        default: path.append(page)
        }
    }
    
    public func pop() {
        switch selectedTab {
        case 0: if !matchingPath.isEmpty { matchingPath.removeLast() }
        case 1: if !chatPath.isEmpty { chatPath.removeLast() }
        case 2: if !myPagePath.isEmpty { myPagePath.removeLast() }
        default: if !path.isEmpty { path.removeLast() }
        }
    }
    
    public func popToRoot() {
        switch selectedTab {
        case 0: matchingPath = NavigationPath()
        case 1: chatPath = NavigationPath()
        case 2: myPagePath = NavigationPath()
        default: path = NavigationPath()
        }
    }
    
    public func present(sheet: MatchingSheet) {
        self.matchingSheet = sheet
    }
    
    public func dismissCallFlow() {
        print("Dismissing call flow from 'matchingPath'...")
        let pathCount = self.matchingPath.count
        
        if pathCount >= 2 {
            self.matchingPath.removeLast(2)
        } else if pathCount >= 1 {
            self.matchingPath.removeLast(1)
        }
    }
    
    public func changeToAuth() {
        // 모든 내비게이션 스택을 초기화합니다.
        path = NavigationPath()
        matchingPath = NavigationPath()
        chatPath = NavigationPath()
        myPagePath = NavigationPath()
        // stackID를 변경하여 NavigationStack 자체를 새로 그리게 합니다.
        stackID = UUID()
    }

    // MARK: - View Builder
    
    @ViewBuilder
    public func build(_ page: IntegrationPage) -> some View {
        AnyView (
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
                TabView(selection: $selectedTab) {
                    NavigationStack(path: $matchingPath) {
                        MatchingMainView(viewModel: matchingViewModel, delegate: self)
                            .navigationBarBackButtonHidden(true)
                            .navigationDestination(for: IntegrationPage.self) { page in self.build(page) }
                    }
                    .tabItem { Label("둘러보기", systemImage: "house") }.tag(0)
                                    
                    NavigationStack(path: $chatPath) {
                        ChatMainView()
                            .navigationBarBackButtonHidden(true)
                            .navigationDestination(for: IntegrationPage.self) { page in self.build(page) }
                    }
                    .tabItem { Label("대화", systemImage: "ellipsis.message") }.tag(1)
                                    
                    NavigationStack(path: $myPagePath) {
                        MyPageView(delegate: self)
                            .navigationBarBackButtonHidden(true)
                            .navigationDestination(for: IntegrationPage.self) { page in self.build(page) }
                    }
                    .tabItem { Label("내 정보", systemImage: "person") }.tag(2)
                }
                .tint(Color.Siso.Primary._100)
                
            case .tutorial:
                TutorialViews(selectedTabIndex: 0, delegate: self)
                    .navigationBarBackButtonHidden(true)
            
            // Profile
            case .complete: CompleteProfileView(delegate: self)
            case .location: LocationProfileView(delegate: self, userProfile: userProfile, viewModel: locationViewModel)
            case .religion: ReligionProfileView(delegate: self, userProfile: userProfile)
            case .smoke: SmokeProfileView(delegate: self, userProfile: userProfile)
            case .drink: DrinkProfileView(delegate: self, userProfile: userProfile)
            case .personality: PersonalityProfileView(delegate: self, userProfile: userProfile)
            case .meeting: MeetingProfileView(delegate: self, userProfile: userProfile)
            case .profile: ProfileView(delegate: self, userProfile: userProfile)
            case .signUp: SignUpProfileView(delegate: self, userProfile: userProfile)
            case .interest: InterestProfileView(delegate: self, userProfile: userProfile)
            case .voice: RecordProfileView(delegate: self, currentPage: .constant(.basic), userProfile: userProfile, mode: .edit)
                
            // MyPage
            case .my: MyPageView(delegate: self)
            case .setting: SettingView(delegate: self)
            case .notification: NotificationView(delegate: self)
                
            // Call
            case .manner(let profile):
                CallMannerView(opponentProfile: profile, delegate: self)
                    .navigationBarBackButtonHidden(true)
               
            case .reportFeedbackPopup:
                ReportFeedBackView(delegate: self)
                    .navigationBarBackButtonHidden(true)
                
            // Chat
            case .main: ChatMainView()
            case .detail: ChatMainView.ChatDetailView(chat: .init(userName: "세종대왕", icon: "person.circle.fill", time: Date().addingTimeInterval(-9000), hasMessages: true))
                
            // Call (통합 뷰)
            case .activeCall:
                ActiveCallView(delegate: self)
                    .navigationBarBackButtonHidden(true)
            }
        )
    }
    
    // ✨ [추가] 시트 빌더 메서드도 여기에 통합합니다.
//    @ViewBuilder
//    public func build(sheet: MatchingSheet) -> some View {
//        switch sheet {
//        case .fullScreenProfile:
//            if let nowWatching = nowWatching {
//                FullScreenProfileView(cardViewModel: nowWatching)
//            }
//        }
//    }
}
