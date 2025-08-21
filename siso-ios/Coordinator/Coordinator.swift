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


public class Coordinator: ObservableObject, AuthCoordinatorDelegate, ProfileCoordinatorDelegate, MatchingCoordinatorDelegate, CallCoordinatorDelegate {

    
    @Published public var stackID: UUID = UUID()
    @Published public var path: NavigationPath = NavigationPath()
    @Published public var profileSheet: ProfileSheet?
    @Published public var callSheet: CallSheet?
    
    var userProfile: UserProfile
    
    var matchingViewModel: MatchingViewModel
    
    var callViewModel: CallViewModel = CallViewModel.shared
    
    public init(userProfile: UserProfile, matchingViewModel: MatchingViewModel) {
        self.userProfile = userProfile
        self.matchingViewModel = matchingViewModel
        self.matchingViewModel.delegate = self
        CallViewModel.shared.delegate = self
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
    public func pushCallingView() {
        print("callingView showed")
    }
    
    public func finishCallAndPopToPreviousView() {
        print("전화 이전 화면으로 돌아가기  showed")
    }
    
    public func pushKeepConnectionPopup() {
        print("인연 이어가기  showed")
    }
    @ViewBuilder
    public func build(_ page: CallPage) -> some View {
        switch page {
        case .connecting:
            // 닉네임만 있으면 그릴 수 있음
            ConnectingView(delegate: self)
        case .called:
            // 프로필만 있으면 그릴 수 있음
            CalledView(callViewModel: callViewModel, delegate: self)
        case .calling:
            // 전화중
            CallingView(callViewModel: callViewModel)
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
            MatchingMainView(viewModel: matchingViewModel, delegate: self)
                .navigationBarBackButtonHidden(true)

        case .chat:
            EmptyView()
            
        case .connecting:
            if let nowWatching = matchingViewModel.nowWatching {
                ConnectingView(delegate: self)
                    .navigationBarBackButtonHidden(true)
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
    
    public func pushCallInteruptPopup() { 
        callSheet = .afterCallPopup
    }
    
    public func pushFullScreenProfileImageView() {
        print("작성예정")
    }
  
    @ViewBuilder
    public func build(_ sheet: CallSheet) -> some View {
        switch sheet {
        case .afterCallPopup:
            AfterCallPopup(cardViewModel: matchingViewModel.cards[0])
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
