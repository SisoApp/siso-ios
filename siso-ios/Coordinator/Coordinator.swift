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

@MainActor
public class Coordinator: ObservableObject {
    // ✨ 1. 현재 활성화된 탭의 Path를 가리키는 계산 프로퍼티
    private var currentPath: Binding<NavigationPath> {
        switch selectedTab {
        case 0:
            return .init(get: { self.matchingPath }, set: { self.matchingPath = $0 })
        case 1:
            return .init(get: { self.chatPath }, set: { self.chatPath = $0 })
        case 2:
            return .init(get: { self.myPagePath }, set: { self.myPagePath = $0 })
        default:
            // 비상용 또는 인증 플로우용
            return .init(get: { self.path }, set: { self.path = $0 })
        }
    }
    
    @Published public var stackID: UUID = UUID()
    
    // MARK: - Navigation Paths
    @Published public var path: NavigationPath = NavigationPath() // 인증/로그인 플로우 용
    @Published public var matchingPath = NavigationPath()
    @Published public var chatPath = NavigationPath()
    @Published public var myPagePath = NavigationPath()
    @Published public var selectedTab: Int = 0
    
    // MARK: - Sheet & Call Properties
    @Published public var authSheet: AuthSheet?
    @Published public var profileSheet: ProfileSheet?
    @Published public var matchingSheet: MatchingSheet?
    @Published public var callPage: CallPage?
    @Published public var callSheet: CallSheet?
    @Published public var activeCallInfo: CallInfoDto?
    @Published public var afterCallSheetProfile: CallInfoDto?
    
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
        // ✅ 4. 수신 전화 Publisher는 계속 사용
        subscribeToIncomingCalls()
    }
    private func subscribeToIncomingCalls() {
        // 이 Publisher는 앱이 실행 중일 때 오는 전화를 처리하기 위해 필요
        callManager.incomingCallPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] callInfo in
                print("📞 Coordinator received incoming call. Changing state to .receiving.")
                // CallManager의 상태를 직접 변경하거나, CallManager의 메서드를 호출
                self?.callManager.receiveCall(info: callInfo)
            }
            .store(in: &cancellables)
    }
    // MARK: - Delegate Method Implementations (여기에 모든 구현을 모읍니다)
    
    // ✨ 2. push, pop 메서드가 매우 간결해집니다.
    public func push(page: IntegrationPage) {
        print("Pushing page: \(page) on tab \(selectedTab)")
        currentPath.wrappedValue.append(page)
    }
    
    public func pop() {
        if !currentPath.wrappedValue.isEmpty {
            currentPath.wrappedValue.removeLast()
        }
    }
    
    // popToRoot도 현재 탭에 맞게 수정 가능
    public func popToRoot() {
        path = NavigationPath()
        matchingPath = NavigationPath()
        chatPath = NavigationPath()
        myPagePath = NavigationPath()
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
            
        case .tutorial:
            TutorialViews(delegate: self)
            
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
        case .my: MyPageView(delegate: self)
        case .setting: SettingView(delegate: self)
        case .notification: NotificationView(delegate: self)
            
            // Call (Enum 수정이 필요합니다)
        case .manner(let opponentProfile):
            CallMannerView(opponentProfile: opponentProfile, delegate: self)
                .navigationBarBackButtonHidden(true)
            
        case .activeCall:
            ActiveCallView(delegate: self)
                .navigationBarBackButtonHidden(true)
            
        case .reportFeedbackPopup:
            ReportFeedBackView(delegate: self)
            
            // Chat
        case .main:
            ChatMainView(delegate: self)
                .navigationBarBackButtonHidden(true)
        case .detail(let chat):
            ChatMainView.ChatDetailView(chat: chat)
        case .notificationChat:
            NotificationChatView()
        }
    }
}
