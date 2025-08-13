//
//  Coordinator.swift
//  auth
//
//  Created by 멘태 on 8/13/25.
//

import SwiftUI

import auth
import profile

public enum Flow: String, Identifiable, Hashable {
    case auth, matching, profile
    
    public var id: String { self.rawValue }
}

public class Coordinator: ObservableObject, AuthCoordinatorDelegate, ProfileCoordinatorDelegate {
    @Published public var path: NavigationPath = NavigationPath()
    
    @Published var profileSheet: ProfilesSheet?
    @Published var authSheet: AuthSheet?
    
    public init() {}
    
    // Comon
    public func pop() {
        path.removeLast()
    }
    
    public func popToRoot() {
        path.removeLast(path.count)
    }
    
    // Auth
    public func pushAuth(_ page: AuthPage) {
        path.append(page)
    }
    
    public func presentAuth(sheet: AuthSheet) {
        authSheet = sheet
    }
    
    public func buildAuthView(_ page: AuthPage) -> AnyView {
        AnyView(build(page))
    }
    
    @ViewBuilder
    public func build(_ page: AuthPage) -> some View {
        switch page {
        case .login:
            SocialView(delegate: self)
        default:
            SocialView(delegate: self)
        }
    }
    
    // Matching
    
    // Profile
    public func pushProfile(_ page: ProfilePage) {
        path.append(page)
    }
    
    public func presentProfile(sheet: ProfilesSheet) {
        self.profileSheet = sheet
    }
    
    public func buildProfileView(_ page: ProfilePage) -> AnyView {
        AnyView(build(page))
    }
    
    @ViewBuilder
    public func build(_ page: ProfilePage) -> some View {
        switch page {
        case .basic:
            BasicProfileView(delegate: self)
        case .hobby:
            HobbyProfileView(delegate: self)
        }
    }
    
    // Flow
    public func changeAuthToProfile() {
        path = NavigationPath()
        pushProfile(.basic)
    }
    
    public func changeProfileToMatching() {
        
    }
    
    public func changeMatchingToAuth() {
        
    }
}
