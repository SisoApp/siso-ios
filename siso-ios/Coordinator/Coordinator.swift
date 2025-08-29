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




@MainActor
public class Coordinator: ObservableObject {
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
    @Published public var afterCallSheetProfile: MatchingProfile?
    
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
        path = NavigationPath()
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
        // ✨ [해결책] switch 문의 각 case가 반환하는 뷰를 AnyView로 감싸서
        // 모든 분기가 'AnyView'라는 동일한 타입을 반환하도록 만듭니다.
        switch page {
            // Auth
        case .login:
            AnyView(SocialView(delegate: self))
        case .accept:
            AnyView(AcceptanceView(delegate: self))
        case .welcome:
            AnyView(WelcomeView(delegate: self))
            
            // Matching
        case .home:
            AnyView(
                TabView(selection: Binding(
                    get: { self.selectedTab },
                    set: { self.selectedTab = $0 }
                )) {
                    NavigationStack(path: Binding(
                        get: { self.matchingPath },
                        set: { self.matchingPath = $0 }
                    )) {
                        MatchingMainView(viewModel: matchingViewModel, delegate: self)
                            .navigationBarBackButtonHidden(true)
                            .navigationDestination(for: IntegrationPage.self) { page in self.build(page) }
                    }
                    .tabItem { Label("둘러보기", systemImage: "house") }.tag(0)
                    
                    NavigationStack(path: Binding(
                        get: { self.chatPath },
                        set: { self.chatPath = $0 }
                    ))  {
                        ChatMainView(delegate: self)
                            .navigationBarBackButtonHidden(true)
                            .navigationDestination(for: IntegrationPage.self) { page in self.build(page) }
                    }
                    .tabItem { Label("대화", systemImage: "ellipsis.message") }.tag(1)
                    
                    NavigationStack(path: Binding(
                        get: { self.myPagePath },
                        set: { self.myPagePath = $0 }
                    ))  {
                        MyPageView(delegate: self)
                            .navigationBarBackButtonHidden(true)
                            .navigationDestination(for: IntegrationPage.self) { page in self.build(page) }
                            
                    }
                    .tabItem { Label("내 정보", systemImage: "person") }.tag(2)
                    .sheet(item: Binding(
                        get: { self.profileSheet },
                        set: { self.profileSheet = $0 }
                    )) { sheet in
                        self.build(sheet: sheet)
                    }
                }
                .tint(Color.Siso.Primary._100)
            )
            
        case .tutorial:
            AnyView(TutorialViews(selectedTabIndex: 0, delegate: self).navigationBarBackButtonHidden(true))
            
            // Profile
        case .complete: AnyView(CompleteProfileView(delegate: self))
        case .location: AnyView(LocationProfileView(delegate: self, userProfile: userProfile, viewModel: locationViewModel))
        case .religion: AnyView(ReligionProfileView(delegate: self, userProfile: userProfile))
        case .smoke: AnyView(SmokeProfileView(delegate: self, userProfile: userProfile))
        case .drink: AnyView(DrinkProfileView(delegate: self, userProfile: userProfile))
        case .personality: AnyView(PersonalityProfileView(delegate: self, userProfile: userProfile))
        case .meeting: AnyView(MeetingProfileView(delegate: self, userProfile: userProfile))
        case .profile: AnyView(ProfileView(delegate: self, userProfile: userProfile))
        case .signUp: AnyView(SignUpProfileView(delegate: self, userProfile: userProfile))
        case .interest: AnyView(InterestProfileView(delegate: self, userProfile: userProfile))
        case .voice: AnyView(RecordProfileView(delegate: self, currentPage: .constant(.basic), userProfile: userProfile, mode: .edit))
        case .image: AnyView(ImageProfileView(delegate: self, currentPage: .constant(.basic), userProfile: userProfile, mode: .edit))
            
            // MyPage
        case .my: AnyView(MyPageView(delegate: self))
        case .setting: AnyView(SettingView(delegate: self))
        case .notification: AnyView(NotificationView(delegate: self))
            
            // Call (Enum 수정이 필요합니다)
        case .manner(let opponentProfile):
            AnyView(CallMannerView(opponentProfile: opponentProfile, delegate: self))
                .navigationBarBackButtonHidden(true)
            
        case .activeCall:
            AnyView(ActiveCallView(delegate: self))
                .navigationBarBackButtonHidden(true)
            
        case .reportFeedbackPopup:
            AnyView(ReportFeedBackView(delegate: self))
            
            // Chat
        case .main:
            AnyView(ChatMainView(delegate: self))
        case .detail:
            AnyView(ChatMainView.ChatDetailView(chat: .init(userName: "세종대왕", icon: "person.circle.fill", time: Date().addingTimeInterval(-9000), hasMessages: true)))
        case .notificationChat:
            AnyView(
                NotificationChatView()
                    .navigationBarBackButtonHidden()
            )
        }
    }
}


#Preview {
    // Preview용 UserProfile
    @Previewable @StateObject var coordinator = Coordinator(userProfile: UserProfile.empty, matchingViewModel: MatchingViewModel.sample, authViewModel: SocialLoginView.LoginViewModel(), locationViewModel: LocationViewModel())

    // TabView 테스트
    coordinator.build(.home)
}
