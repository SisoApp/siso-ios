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

public enum Sheet: String, Identifiable {
    case temp
    
    public var id: String { self.rawValue }
}

public enum FullScreenCover: String, Identifiable, Hashable {
    case imageHelper
    
    public var id: String { self.rawValue }
}

public class Coordinator: ObservableObject, AuthCoordinatorDelegate, ProfileCoordinatorDelegate, MatchingCoordinatorDelegate {
    public func pushToContactingView() {
        <#code#>
    }
    
    public func pushToCallingView() {
        <#code#>
    }
    
    public func pushToChatView() {
        <#code#>
    }
    
    public func pushCallInteruptPopup() {
        <#code#>
    }
    
    public func pushFullScreenProfileImageView() {
        <#code#>
    }
    
    @Published public var stackID: UUID = UUID()
    @Published public var path: NavigationPath = NavigationPath()
    @Published public var sheet: Sheet?
    @Published public var fullScreenCover: FullScreenCover?
    
    public init() {}
    
    // Common
    public func pop() {
        path.removeLast()
    }
    
    public func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    public func build(sheet: Sheet) -> some View {
        switch sheet {
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    public func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .imageHelper:
            EmptyView()
        }
    }
    
    // Auth Page
    public func pushAuth(_ page: AuthPage) {
        path.append(page)
    }
    
    public func buildAuthView(_ page: AuthPage) -> AnyView {
        AnyView(build(page))
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
