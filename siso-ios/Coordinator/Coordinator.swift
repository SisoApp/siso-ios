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
    @Published public var afterCallSheetProfile: UserProfileServer?
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
        
        // 수신 전화 fullScreenCover를 위한 로직도 여기에 추가하면 좋습니다.
        // ...
    }
    // ** Common
    public func pop() {
        path.removeLast()
    }
    
    public func popToRoot() {
        path.removeLast(path.count - 1)
    }
    
    public func dismissCallFlow() {
        print("Dismissing call flow...")
        
        // 현재 스택에 쌓인 뷰의 개수를 확인합니다.
        let pathCount = self.path.count
        
        // 통화 플로우는 'manner' -> 'activeCall' 순서로 2개의 뷰로 구성됩니다.
        // 스택에 2개 이상의 뷰가 쌓여있고, 통화 플로우가 맞는지 대략적으로 추측할 수 있습니다.
        // (더 정확하게 하려면 각 뷰로 진입할 때 플래그를 세우는 방법도 있지만 복잡해집니다.)
        
        // 현재 로직상 통화가 끝나면 스택의 마지막 두 개는 항상 manner와 activeCall 입니다.
        // 따라서 안전하게 2개를 지웁니다.
        if pathCount >= 2 {
            print("Popping 2 views (activeCall, manner) from the stack.")
            self.path.removeLast(2)
        } else if pathCount == 1 {
            // 혹시라도 스택에 activeCall 하나만 있는 예외적인 경우
            print("Popping 1 view from the stack.")
            self.path.removeLast(1)
        }
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
            //        case .connecting(let opponentProfile):
            //            ConnectingView(opponentProfile: opponentProfile, delegate: self)
            //                .navigationBarBackButtonHidden(true)
            //        case .calling(let viewModel):
            //            CallingView(inCallViewModel: viewModel,
            //                        delegate: self)
            //            .navigationBarBackButtonHidden(true)
            //        case .incomingCall(let info):
            //            IncommingCallView(callInfo: info,
            //                              delegate: self)
            //            .navigationBarBackButtonHidden(true)
        case .reportFeedbackPopup:
            ReportFeedBackView(delegate: self)
                .navigationBarBackButtonHidden(true)
            
        case .main:
            ChatMainView()
        case .detail:
            ChatMainView.ChatDetailView(chat: ChatMainView.RecentChat(userName: "세종대왕", icon: "person.circle.fill", time: Date().addingTimeInterval(-9000), hasMessages: true))
        case .activeCall: // 통합된 케이스
            ActiveCallView(delegate: self)
                .navigationBarBackButtonHidden(true)
        }
    }
}

extension IntegrationPage: Equatable, Hashable {
    // Equatable 프로토콜 구현 (==)
    public static func == (lhs: IntegrationPage, rhs: IntegrationPage) -> Bool {
        switch (lhs, rhs) {
        case (.login, .login), (.accept, .accept), (.home, .home), (.manner, .manner), (.reportFeedbackPopup, .reportFeedbackPopup):
            return true // 연관값 없는 케이스들
        case (.activeCall, .activeCall): // 새로운 케이스 추가
            return true
            //        case (.connecting(let lhsProfile), .connecting(let rhsProfile)):
            //            return lhsProfile.id == rhsProfile.id // id로 비교
            //        case (.calling(let lhsVM), .calling(let rhsVM)):
            //            return lhsVM === rhsVM // ViewModel은 클래스이므로 인스턴스 자체를 비교 (===)
            //        case (.incomingCall(let lhsInfo), .incomingCall(let rhsInfo)):
            //            return lhsInfo.id == rhsInfo.id // 정보의 고유 ID로 비교
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
            
        case .activeCall: // 새로운 케이스 추가
            hasher.combine("activeCall")
            
            //        case .connecting(let opponentProfile):
            //            hasher.combine("connecting")
            //            hasher.combine(opponentProfile.id) // 연관값의 고유 식별자를 해싱
            //        case .calling(let viewModel):
            //            hasher.combine("calling")
            //            hasher.combine(viewModel.id) // ViewModel의 고유 식별자를 해싱
            //        case .incomingCall(let callInfo):
            //            hasher.combine("incomingCall")
            //            hasher.combine(callInfo.id) // callInfo의 고유 식별자를 해싱
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
