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
import mypage

public class Coordinator: ObservableObject, AuthCoordinatorDelegate, ProfileCoordinatorDelegate, MatchingCoordinatorDelegate, MyPageCoordinatorDelegate {
    @Published public var stackID: UUID = UUID()
    @Published public var path: NavigationPath = NavigationPath()
    @Published public var profileSheet: ProfileSheet?
    @Published public var matchingSheet: MatchingSheet?
    
    var userProfile: UserProfile
    var matchingViewModel: MatchingViewModel
    
    public init(userProfile: UserProfile, matchingViewModel: MatchingViewModel) {
        self.userProfile = userProfile
        self.matchingViewModel = matchingViewModel
        self.matchingViewModel.delegate = self
        CallManager.shared.delegate = self
    }
    
    // Common
    public func pop() {
        path.removeLast()
    }
    
    public func popToRoot() {
        path.removeLast(path.count - 1)
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
    
    // Matching Page
    public func pushMatching(_ page: MatchingPage) {
        path.append(page)
    }
    
    @ViewBuilder
    public func build(_ page: MatchingPage) -> some View {
        switch page {
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
        }
    }
    public func popToMainView() {
        print("poptoMain")
    }
    
    public func pushContactingView() {
        print("contactingView로 진행합니다")
        path.append(MatchingPage.contacting)
    }
    
    public func pushCallingView() { // 전화중 (이야기중)
        path.append(MatchingPage.calling)
    }
    
    public func pushChatView() { // 채팅 하기 누른경우
        path.append(MatchingPage.chat)
    }
    
    public func pushCallInteruptPopup() { 
        matchingSheet = .afterCallPopup
    }
    
    public func pushFullScreenProfileImageView() {
        print("작성예정")
    }
  
    @ViewBuilder
    public func build(_ sheet: MatchingSheet) -> some View {
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
        case .location:
            LocationProfileView(delegate: self)
        case .religion:
            ReligionProfileView(delegate: self)
        case .smoke:
            SmokeProfileView(delegate: self)
        case .drink:
            DrinkProfileView(delegate: self)
        case .personality:
            PersonalityProfileView(delegate: self)
        case .meeting:
            MeetingProfileView(delegate: self)
        case .profile:
            ProfileView(delegate: self)
        }
    }
    
    @ViewBuilder
    public func build(sheet: ProfileSheet) -> some View {
        switch sheet {
        case .imageHelper(let completion):
            ImageHelperSheet(delegate: self, userProfile: userProfile, completion: completion)
        case .cameraSheet:
            ImagePicker(userProfile: userProfile)
        case .location:
            LocationProfileSheet(delegate: self)
        }
    }
    
    // MyPage
    public func pushMyPage(_ page: MyPage) {
        path.append(page)
    }
    
    @ViewBuilder
    public func build(_ page: MyPage) -> some View {
        switch page {
        case .main:
            MyPageView(delegate: self)
        case .setting:
            EmptyView()
        case .notification:
            EmptyView()
        }
    }
    
    // Flow
    public func changeAuthToProfile() {
        stackID = UUID()
        path = NavigationPath()
        
        Task { @MainActor in
            try await Task.sleep(nanoseconds: 50_000_000)
            withAnimation(.easeInOut) {
                pushProfile(.basic)
            }
        }
        
    }
    
    public func changeProfileToMatching() {
        stackID = UUID()
        path = NavigationPath()
        
        Task { @MainActor in
            try await Task.sleep(nanoseconds: 50_000_000)
            withAnimation(.easeInOut) {
                pushMatching(.home)
            }
        }
    }
    
    public func pushMyPageToProfile() {
        pushProfile(.basic)
    }
    
    public func changeMatchingToAuth() {
        
    }
}
