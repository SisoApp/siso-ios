//
//  Coordinator.swift
//  auth
//
//  Created by 멘태 on 8/13/25.
//

import SwiftUI

import auth
import profile

public class Coordinator: ObservableObject, AuthCoordinatorDelegate, ProfileCoordinatorDelegate {
    @Published public var stackID: UUID = UUID()
    @Published public var path: NavigationPath = NavigationPath()
    @Published public var profileCover: ProfileFullScreenCover?
    
    public init() {}
    
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
    
    // Profile Page
    public func pushProfile(_ page: ProfilePage) {
        path.append(page)
    }
    
    public func presentProfile(cover: ProfileFullScreenCover) {
        profileCover = cover
    }
    
    public func dismissProfileCover() {
        profileCover = nil
    }
    
    @ViewBuilder
    public func build(_ page: ProfilePage) -> some View {
        switch page {
        case .basic:
            BasicProfileView(delegate: self)
        case .interest:
            InterestProfileView(delegate: self)
        case .image:
            ImageProfileView(delegate: self)
        case .introduce:
            IntroduceProfileView(delegate: self)
        }
    }
    
    @ViewBuilder
    public func build(fullScreenCover: ProfileFullScreenCover) -> some View {
        switch fullScreenCover {
        case .imageHelper:
            ImageHelperCover(delegate: self)
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
