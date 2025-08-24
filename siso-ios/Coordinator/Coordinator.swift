//
//  Coordinator.swift
//  auth
//
//  Created by 멘태 on 8/13/25.
//

import SwiftUI
import Foundation
import auth
import profile
import matching
import call
import model
import Combine

public class Coordinator: ObservableObject, AuthCoordinatorDelegate, ProfileCoordinatorDelegate, MatchingCoordinatorDelegate, CallCoordinatorDelegate {
    public func pushCallInteruptPopup() {
        print("추후 구현")
    }
    
    public func pushCallingView() {
        print("추후 구현")
    }
    
    public func finishCallAndPopToPreviousView() {
        print("추후 구현")

    }
    
    public func pushKeepConnectionPopup() {
        print("추후 구현")

    }
    
    
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
    // 타인의 카드뷰를 가지고 있는 매칭 뷰 모델
    var matchingViewModel: MatchingViewModel
    // 콜 뷰들을 그리기 위한 카드 뷰
    // 초기 생성 시 전화 상대가 없기 때문에 opponentProfile은 nil로 되어 있다.
    var inCallViewModel: InCallViewModel? = nil
    // 초기 생성 시 전화 상대가 없기 때문에 OpponetUserProfile도 nil이 되어있다
    var inCommingCallInfo: IncomingCallInfo? = nil
    
    public init(userProfile: UserProfile, matchingViewModel: MatchingViewModel) {
        self.userProfile = userProfile
        self.matchingViewModel = matchingViewModel
        self.matchingViewModel.delegate = self
    }
    
    // Common
    public func pop() {
        path.removeLast()
    }
    
    public func popToRoot() {
        path.removeLast(path.count)
    }
    
    // Auth Page
    public func pushAuth(_ page: AuthPage) {
        path.append(page)
    }
    
    @ViewBuilder
    public func build(_ page: AuthPage) -> some View {
        switch page {
        case .login:
            SocialView(delegate: self)
        case .accept:
            AcceptanceView(delegate: self)
        case .welcome:
            WelcomeView(delegate: self)
        }
    }
    
    // Call
    // ✅ CallManager를 구독하여 '화면 전환'만 담당하는 핵심 로직
       private func subscribeToCallManager() {
           
           // 1. 메인 통화 상태 변화 구독
           callManager.$callState
               .receive(on: DispatchQueue.main)
               .sink { [weak self] state in
                   // 상태에 따라 어떤 모달을 띄울지와 필요한 데이터를 결정
                   switch state {
                   case .idle:
                       self?.activeCallPage = nil
                       self?.activeCallInfo = nil
                       
                   case .receiving(let info):
                       self?.activeCallInfo = info
                       self?.activeCallPage = .called
                       
                   case .connecting(let info):
                       self?.activeCallInfo = info
                       self?.activeCallPage = .connecting
                       
                   case .inCall(let info):
                       self?.activeCallInfo = info
                       self?.activeCallPage = .calling
                   }
               }
               .store(in: &cancellables)
               
           // '일회성' 팝업 이벤트 구독
               callManager.showAfterCallPopupPublisher
                   .receive(on: DispatchQueue.main)
                   .sink { [weak self] opponentProfile in
                       // ✅ 받은 opponentProfile 데이터를 CallSheet 상태에 직접 담아줍니다.
                       self?.callSheet = .afterCallPopup(opponent: opponentProfile)
                   }
                   .store(in: &cancellables)
       }
       
       // ... 나머지 build 함수들은 이전 제안과 거의 동일 ...

    @ViewBuilder
    public func build(_ page: CallPage) -> some View {
        switch page {
        case .connecting:
            // 닉네임만 있으면 그릴 수 있음
            ConnectingView(opponentProfile: activeCallInfo!.opponentProfile)
        case .called:
            // 프로필만 있으면 그릴 수 있음
            CalledView(callInfo: activeCallInfo!)
        case .calling:
            // 전화중
            CallingView(inCallViewModel: inCallViewModel!, delegate: self)
        }
    }
    
    // Matching Page
    public func pushMatching(_ page: MatchingPage) {
        path.append(page)
    }
    
    public func buildMatchingView(_ page: MatchingPage) -> AnyView {
        AnyView(build(page))
    }
    
    @ViewBuilder
    public func build(_ page: MatchingPage) -> some View {
        switch page {
        case .home:
            EmptyView()
            
        case .chat:
            EmptyView()
            
        case .connecting:
            // ✅ activeCallInfo가 nil이 아니고, 그 안의 opponentProfile을 안전하게 가져옵니다.
            // ✅ nowWatching도 함께 확인합니다.
            if let info = activeCallInfo, let nowWatching = matchingViewModel.nowWatching {
                ConnectingView(opponentProfile: info.opponentProfile) // 이제 `info.opponentProfile`은 절대 nil이 아닙니다.
                    .navigationBarBackButtonHidden(true)
            } else {
                // 만약 필요한 정보가 없다면, 로딩 화면이나 에러 메시지를 보여주는 것이 좋습니다.
                // 이렇게 하면 예기치 않은 상태에서도 앱이 충돌하지 않습니다.
                VStack {
                    Text("연결 정보를 불러오는 중입니다...")
                    ProgressView()
                }
            }
        }
    }
    
    public func popToMainView() {
        print("poptoMain")
    }
    
    public func pushContactingView() {
        print("contactingView로 진행합니다")
        path.append(MatchingPage.connecting)
    }
    
    public func pushChatView() { // 채팅 하기 누른경우
        path.append(MatchingPage.chat)
    }
    
    public func pushFullScreenProfileImageView() {
        print("작성예정")
    }
    
    @ViewBuilder
    public func build(_ sheet: CallSheet) -> some View {
        switch sheet {
        // ✅ 'case let' 구문을 사용하여 enum의 연관 값을 안전하게 추출합니다.
        case .afterCallPopup(let opponentProfile):
            
            // 이제 'opponentProfile'은 옵셔널이 아닌, 확실한 UserProfileServer 타입입니다.
            AfterCallPopup(opponentProfile: opponentProfile)
        }
    }
    
    // Profile Page
    public func pushProfile(_ page: ProfilePage) {
        path.append(page)
    }
    
    public func presentProfile(sheet: ProfileSheet) {
        profileSheet = sheet
    }
    
    public func dismissProfileSheet() {
        profileSheet = nil
    }
    
    @ViewBuilder
    public func build(_ page: ProfilePage) -> some View {
        switch page {
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
    
    @ViewBuilder
    public func build(sheet: ProfileSheet) -> some View {
        switch sheet {
        case .imageHelper(let completion):
            ImageHelperSheet(delegate: self, userProfile: userProfile, completion: completion)
        case .cameraSheet:
            ImagePicker(userProfile: userProfile)
        }
    }
    
    
    // Flow
    public func changeAuthToProfile() {
        stackID = UUID()
        path = NavigationPath()
        
        withAnimation(.easeInOut(duration: 0.35)) { [weak self] in
            self?.pushProfile(.basic)
        }
    }
    
    public func changeProfileToMatching() {
        
    }
    
    public func changeMatchingToAuth() {
        
    }
}
