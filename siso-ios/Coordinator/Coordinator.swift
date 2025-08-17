//
//  Coordinator.swift
//  auth
//
//  Created by 멘태 on 8/13/25.
//

import SwiftUI

import auth
import profile
import matching

public class Coordinator: ObservableObject, AuthCoordinatorDelegate, ProfileCoordinatorDelegate {
    @Published public var stackID: UUID = UUID()
    @Published public var path: NavigationPath = NavigationPath()
    @Published public var profileSheet: ProfileSheet?
    
    var userProfile: UserProfile
    
    public init(userProfile: UserProfile) {
        self.userProfile = userProfile
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
            MatchingView(delegate: self)
        case .beCalled:
            MatchingCalledView()
        case .call:
            MatchingContactingView()
        case .popup:
            AfterCallPopup()
        case .chat:
            EmptyView()
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
